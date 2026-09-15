local mod = get_mod("visual_cues")

local UIRenderer = UIRenderer
local UISceneGraph = UISceneGraph
local UIWidget = UIWidget
local UILayer = UILayer
local math = math
local table = table

local notification_queue = mod:persistent_table("notification_queue", {})
local warning_queue = mod:persistent_table("warning_queue", {})

local MAX_NOTIFICATIONS = 4

local LINE_SPACING = 1.3
local FADE_IN_DURATION = 0.2
local FADE_OUT_DURATION = 0.6

local WARNING_FADE_IN_DURATION = 0.05
local WARNING_FADE_OUT_DURATION = 0.25

-- { alpha, red, green, blue }.
local TEXT_COLOR = { 255, 255, 176, 64 }
local SHADOW_COLOR = { 255, 0, 0, 0 }
local WARNING_COLOR = { 255, 255, 48, 48 }

local scenegraph_definition = {
    screen = {
        scale = "fit",
        size = { 1920, 1080 },
        position = { 0, 0, UILayer.default },
    },
}

local function create_notification_widget()
    return {
        scenegraph_id = "screen",
        element = {
            passes = {
                { pass_type = "text", style_id = "shadow", text_id = "text" },
                { pass_type = "text", style_id = "text",   text_id = "text" },
            },
        },
        content = {
            text = "",
        },
        style = {
            text = {
                dynamic_font = true,
                font_type = "hell_shark",
                font_size = 32,
                horizontal_alignment = "center",
                vertical_alignment = "center",
                pixel_perfect = true,
                word_wrap = true,
                text_color = table.clone(TEXT_COLOR),
                offset = { 0, 0, 2 },
            },
            shadow = {
                dynamic_font = true,
                font_type = "hell_shark",
                font_size = 32,
                horizontal_alignment = "center",
                vertical_alignment = "center",
                pixel_perfect = true,
                word_wrap = true,
                text_color = table.clone(SHADOW_COLOR),
                offset = { 2, -2, 1 },
            },
        },
        offset = { 0, 0, 0 },
    }
end

local function create_warning_widget()
    return {
        scenegraph_id = "screen",
        element = {
            passes = {
                { pass_type = "text", style_id = "shadow", text_id = "text" },
                { pass_type = "text", style_id = "text",   text_id = "text" },
            },
        },
        content = {
            text = "!",
        },
        style = {
            text = {
                dynamic_font = true,
                font_type = "hell_shark",
                font_size = 64,
                horizontal_alignment = "center",
                vertical_alignment = "center",
                pixel_perfect = true,
                word_wrap = true,
                text_color = table.clone(WARNING_COLOR),
                offset = { 0, 0, 2 },
            },
            shadow = {
                dynamic_font = true,
                font_type = "hell_shark",
                font_size = 64,
                horizontal_alignment = "center",
                vertical_alignment = "center",
                pixel_perfect = true,
                word_wrap = true,
                text_color = table.clone(SHADOW_COLOR),
                offset = { 3, -3, 1 },
            },
        },
        offset = { 0, 0, 0 },
    }
end

local function fade_progress(entry, t, fade_in_duration, fade_out_duration)
    local fade_in = (t - entry.shown_at) / (fade_in_duration or FADE_IN_DURATION)
    local fade_out = (entry.expires_at - t) / (fade_out_duration or FADE_OUT_DURATION)

    -- taking the lower of the two keeps short durations from popping in at full opacity
    return math.easeOutCubic(math.clamp(math.min(fade_in, fade_out), 0, 1))
end

VisualCuesHud = class(VisualCuesHud)

VisualCuesHud.init = function(self, parent, ingame_ui_context)
    self._parent = parent
    self._ui_renderer = ingame_ui_context.ui_renderer
    self._input_manager = ingame_ui_context.input_manager
    self._render_settings = { snap_pixel_positions = true }
    self._notifications = {}
    self._warning = nil

    self:create_ui_elements()
end

VisualCuesHud.create_ui_elements = function(self)
    UIRenderer.clear_scenegraph_queue(self._ui_renderer)

    self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
    self._widgets = {}

    for i = 1, MAX_NOTIFICATIONS do
        self._widgets[i] = UIWidget.init(create_notification_widget())
    end

    self._warning_widget = UIWidget.init(create_warning_widget())
end

VisualCuesHud.resolution_modified = function(self)
    self:create_ui_elements()
end

VisualCuesHud.destroy = function(self)
    self._notifications = {}
    self._warning = nil
    self._widgets = nil
    self._warning_widget = nil
    self._ui_scenegraph = nil
end

VisualCuesHud._collect_queued_notifications = function(self, t)
    local notifications = self._notifications

    while #notification_queue > 0 do
        local queued = table.remove(notification_queue, 1)

        notifications[#notifications + 1] = {
            text = queued.text,
            color = queued.color,
            font_size = queued.font_size,
            offset_x = queued.offset_x,
            offset_y = queued.offset_y,
            shown_at = t,
            expires_at = t + queued.duration,
        }

        if #notifications > MAX_NOTIFICATIONS then
            table.remove(notifications, 1)
        end
    end
end

VisualCuesHud._collect_queued_warnings = function(self, t)
    -- any attack restarts the marker, repeated attacks keep it up instead of making it flicker
    while #warning_queue > 0 do
        local queued = table.remove(warning_queue, 1)

        self._warning = {
            font_size = queued.font_size,
            offset_x = queued.offset_x,
            offset_y = queued.offset_y,
            shown_at = t,
            expires_at = t + queued.duration,
        }
    end

    if self._warning and self._warning.expires_at <= t then
        self._warning = nil
    end
end

VisualCuesHud._draw_warning = function(self, t)
    local warning = self._warning
    local widget = self._warning_widget
    local style = widget.style
    local font_size = warning.font_size

    style.text.font_size = font_size
    style.shadow.font_size = font_size

    local alpha = 255 * fade_progress(warning, t, WARNING_FADE_IN_DURATION, WARNING_FADE_OUT_DURATION)

    style.text.text_color[1] = alpha
    style.shadow.text_color[1] = alpha

    widget.offset[1] = warning.offset_x
    widget.offset[2] = warning.offset_y

    UIRenderer.draw_widget(self._ui_renderer, widget)
end

VisualCuesHud._remove_expired_notifications = function(self, t)
    local notifications = self._notifications

    for i = #notifications, 1, -1 do
        if notifications[i].expires_at <= t then
            table.remove(notifications, i)
        end
    end
end

VisualCuesHud._draw = function(self, dt, t)
    local ui_renderer = self._ui_renderer
    local input_service = self._input_manager:get_service("Player")
    local notifications = self._notifications
    local count = #notifications

    UIRenderer.begin_pass(ui_renderer, self._ui_scenegraph, input_service, dt, nil, self._render_settings)

    for i = 1, count do
        local notification = notifications[i]
        local widget = self._widgets[i]
        local style = widget.style
        local font_size = notification.font_size
        local alpha = 255 * fade_progress(notification, t)
        local text_color = style.text.text_color
        local color = notification.color or TEXT_COLOR

        widget.content.text = notification.text

        style.text.font_size = font_size
        style.shadow.font_size = font_size

        text_color[2] = color[2]
        text_color[3] = color[3]
        text_color[4] = color[4]
        text_color[1] = alpha
        style.shadow.text_color[1] = alpha

        widget.offset[1] = notification.offset_x
        widget.offset[2] = notification.offset_y + (count - i) * font_size * LINE_SPACING

        UIRenderer.draw_widget(ui_renderer, widget)
    end

    if self._warning then
        self:_draw_warning(t)
    end

    UIRenderer.end_pass(ui_renderer)
end

-- called only while the component is in a visible group, so this stops drawing on its own in menus, cutscenes, etc.
VisualCuesHud.update = function(self, dt, t)
    self:_collect_queued_notifications(t)
    self:_collect_queued_warnings(t)
    self:_remove_expired_notifications(t)

    if #self._notifications > 0 or self._warning then
        self:_draw(dt, t)
    end
end

mod:register_hud_component({
    class_name = "VisualCuesHud",
    visibility_groups = { "alive" }, -- includes being knocked down
    use_hud_scale = true,
})
