#include "include/cef_app.h"

#define trace(...) { printf("[%s:%d] ", __RELFILE__, __LINE__); printf(__VA_ARGS__); printf("\n"); fflush(stdout); }

class RenderHandler : public CefRenderHandler {
public:
    int m_width = 1280;
    int m_height = 720;
    bool m_needsRedraw = false;
    uint8_t* m_rgba = nullptr;

    RenderHandler(int _width, int _height) : m_width(_width), m_height(_height) {}

public: // CefRenderHandler
    void GetViewRect(CefRefPtr<CefBrowser> browser, CefRect& rect);
    void OnPaint(CefRefPtr<CefBrowser> browser, PaintElementType type, const RectList& dirtyRects, const void* buffer, int width, int height);
public:
    IMPLEMENT_REFCOUNTING(RenderHandler);
};

class BrowserClient : public CefClient {
public:
    CefRefPtr<CefRenderHandler> renderHandler;

    BrowserClient(RenderHandler* renderHandler) : renderHandler(renderHandler) {}

    virtual CefRefPtr<CefRenderHandler> GetRenderHandler() {
        return renderHandler;
    }

public:
    IMPLEMENT_REFCOUNTING(BrowserClient);
};

extern RenderHandler* renderHandler;
extern CefRefPtr<BrowserClient> browserClient;
extern CefRefPtr<CefBrowser> browser;
extern CefRefPtr<CefApp> appPtr;
#pragma once
#include <vector>
#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
#include <optional>
#endif
#include <stdint.h>
#include <cstring>
#include <tuple>
using namespace std;

#define dllg /* tag */
#define dllgm /* tag;mangled */

#if defined(_WINDOWS)
#define dllx extern "C" __declspec(dllexport)
#define dllm __declspec(dllexport)
#elif defined(GNUC)
#define dllx extern "C" __attribute__ ((visibility("default"))) 
#define dllm __attribute__ ((visibility("default"))) 
#else
#define dllx extern "C"
#define dllm /* */
#endif

#ifdef _WINDEF_
/// auto-generates a window_handle() on GML side
typedef HWND GAME_HWND;
#endif

/// auto-generates an asset_get_index("argument_name") on GML side
typedef int gml_asset_index_of;
/// Wraps a C++ pointer for GML.
template <typename T> using gml_ptr = T*;
/// Same as gml_ptr, but replaces the GML-side pointer by a nullptr after passing it to C++
template <typename T> using gml_ptr_destroy = T*;

class gml_buffer {
private:
	uint8_t* _data;
	int32_t _size;
	int32_t _tell;
public:
	gml_buffer() : _data(nullptr), _tell(0), _size(0) {}
	gml_buffer(uint8_t* data, int32_t size, int32_t tell) : _data(data), _size(size), _tell(tell) {}

	inline uint8_t* data() { return _data; }
	inline int32_t tell() { return _tell; }
	inline int32_t size() { return _size; }
};

class gml_istream {
	uint8_t* pos;
	uint8_t* start;
public:
	gml_istream(void* origin) : pos((uint8_t*)origin), start((uint8_t*)origin) {}

	template<class T> T read() {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be read");
		T result{};
		std::memcpy(&result, pos, sizeof(T));
		pos += sizeof(T);
		return result;
	}

	char* read_string() {
		char* r = (char*)pos;
		while (*pos != 0) pos++;
		pos++;
		return r;
	}

	template<class T> std::vector<T> read_vector() {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be read");
		auto n = read<uint32_t>();
		std::vector<T> vec(n);
		std::memcpy(vec.data(), pos, sizeof(T) * n);
		pos += sizeof(T) * n;
		return vec;
	}
	std::vector<const char*> read_string_vector() {
		auto n = read<uint32_t>();
		std::vector<const char*> vec(n);
		for (auto i = 0u; i < n; i++) {
			vec[i] = read_string();
		}
		return vec;
	}

	gml_buffer read_gml_buffer() {
		auto _data = (uint8_t*)read<int64_t>();
		auto _size = read<int32_t>();
		auto _tell = read<int32_t>();
		return gml_buffer(_data, _size, _tell);
	}

	#pragma region Tuples
	#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
	template<typename... Args>
	std::tuple<Args...> read_tuple() {
		std::tuple<Args...> tup;
		std::apply([this](auto&&... arg) {
			((
				arg = this->read<std::remove_reference_t<decltype(arg)>>()
				), ...);
			}, tup);
		return tup;
	}

	template<class T> optional<T> read_optional() {
		if (read<bool>()) {
			return read<T>;
		} else return {};
	}
	#else
	template<class A, class B> std::tuple<A, B> read_tuple() {
		A a = read<A>();
		B b = read<B>();
		return std::tuple<A, B>(a, b);
	}

	template<class A, class B, class C> std::tuple<A, B, C> read_tuple() {
		A a = read<A>();
		B b = read<B>();
		C c = read<C>();
		return std::tuple<A, B, C>(a, b, c);
	}

	template<class A, class B, class C, class D> std::tuple<A, B, C, D> read_tuple() {
		A a = read<A>();
		B b = read<B>();
		C c = read<C>();
		D d = read<d>();
		return std::tuple<A, B, C, D>(a, b, c, d);
	}
	#endif
};

class gml_ostream {
	uint8_t* pos;
	uint8_t* start;
public:
	gml_ostream(void* origin) : pos((uint8_t*)origin), start((uint8_t*)origin) {}

	template<class T> void write(T val) {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be write");
		memcpy(pos, &val, sizeof(T));
		pos += sizeof(T);
	}

	void write_string(const char* s) {
		for (int i = 0; s[i] != 0; i++) write<char>(s[i]);
		write<char>(0);
	}

	template<class T> void write_vector(std::vector<T>& vec) {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be write");
		auto n = vec.size();
		write<uint32_t>((uint32_t)n);
		memcpy(pos, vec.data(), n * sizeof(T));
		pos += n * sizeof(T);
	}

	void write_string_vector(std::vector<const char*> vec) {
		auto n = vec.size();
		write<uint32_t>((uint32_t)n);
		for (auto i = 0u; i < n; i++) {
			write_string(vec[i]);
		}
	}

	#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
	template<typename... Args>
	void write_tuple(std::tuple<Args...> tup) {
		std::apply([this](auto&&... arg) {
			(this->write(arg), ...);
			}, tup);
	}

	template<class T> void write_optional(optional<T>& val) {
		auto hasValue = val.has_value();
		write<bool>(hasValue);
		if (hasValue) write<T>(val.value());
	}
	#else
	template<class A, class B> void write_tuple(std::tuple<A, B>& tup) {
		write<A>(std::get<0>(tup));
		write<B>(std::get<1>(tup));
	}
	template<class A, class B, class C> void write_tuple(std::tuple<A, B, C>& tup) {
		write<A>(std::get<0>(tup));
		write<B>(std::get<1>(tup));
		write<C>(std::get<2>(tup));
	}
	template<class A, class B, class C, class D> void write_tuple(std::tuple<A, B, C, D>& tup) {
		write<A>(std::get<0>(tup));
		write<B>(std::get<1>(tup));
		write<C>(std::get<2>(tup));
		write<D>(std::get<3>(tup));
	}
	#endif
};
#include "gml_ext.h"
extern void cef_mouse_flag(int rawFlag, int enable);
dllx double cef_mouse_flag_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_rawFlag;
	_arg_rawFlag = _in.read<int>();
	int _arg_enable;
	_arg_enable = _in.read<int>();
	cef_mouse_flag(_arg_rawFlag, _arg_enable);
	return 1;
}

extern bool cef_mouse_event(int kind, int time);
dllx double cef_mouse_event_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_kind;
	_arg_kind = _in.read<int>();
	int _arg_time;
	_arg_time = _in.read<int>();
	return cef_mouse_event(_arg_kind, _arg_time);
}

extern bool cef_mouse_move(int nx, int ny, int time, bool canmouseover);
dllx double cef_mouse_move_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_nx;
	_arg_nx = _in.read<int>();
	int _arg_ny;
	_arg_ny = _in.read<int>();
	int _arg_time;
	_arg_time = _in.read<int>();
	bool _arg_canmouseover;
	_arg_canmouseover = _in.read<bool>();
	return cef_mouse_move(_arg_nx, _arg_ny, _arg_time, _arg_canmouseover);
}

#include <windows.h>

#include "include/cef_command_line.h"
#include "include/cef_sandbox_win.h"
#include "tests/cefsimple/simple_app.h"
#include "tests/shared/browser/util_win.h"
#include <algorithm>
#include <execution>

#include <windowsx.h>
#include "gml_ext.h"
#include "cefgml.h"

#define __RELFILE__ "cefgml-handler"

/*
inject user-input by calling - non-trivial for non-windows -
checkout the cefclient source and the platform specific cpp, like cefclient_osr_widget_gtk.cpp for linux
browser->GetHost()->SendKeyEvent(...);
browser->GetHost()->SendMouseMoveEvent(...);
browser->GetHost()->SendMouseClickEvent(...);
browser->GetHost()->SendMouseWheelEvent(...);
from https://github.com/qwertzui11/cef_osr/blob/master/osr.cpp
*/

// adapted from osr_window_win.cc
void OnKeyEvent(UINT message, WPARAM wParam, LPARAM lParam) {
    CefKeyEvent event;
    event.windows_key_code = wParam;
    event.native_key_code = lParam;
    event.is_system_key = message == WM_SYSCHAR || message == WM_SYSKEYDOWN ||
        message == WM_SYSKEYUP;

    if (message == WM_KEYDOWN || message == WM_SYSKEYDOWN) {
        event.type = KEYEVENT_RAWKEYDOWN;
    } else if (message == WM_KEYUP || message == WM_SYSKEYUP) {
        event.type = KEYEVENT_KEYUP;
    } else {
        event.type = KEYEVENT_CHAR;
    }
    event.modifiers = client::GetCefKeyboardModifiers(wParam, lParam);

    // mimic alt-gr check behaviour from
    // src/ui/events/win/events_win_utils.cc: GetModifiersFromKeyState
    if ((event.type == KEYEVENT_CHAR) && client::IsKeyDown(VK_RMENU)) {
        // reverse AltGr detection taken from PlatformKeyMap::UsesAltGraph
        // instead of checking all combination for ctrl-alt, just check current char
        HKL current_layout = ::GetKeyboardLayout(0);

        // https://docs.microsoft.com/en-gb/windows/win32/api/winuser/nf-winuser-vkkeyscanexw
        // ... high-order byte contains the shift state,
        // which can be a combination of the following flag bits.
        // 1 Either SHIFT key is pressed.
        // 2 Either CTRL key is pressed.
        // 4 Either ALT key is pressed.
        SHORT scan_res = ::VkKeyScanExW(wParam, current_layout);
        constexpr auto ctrlAlt = (2 | 4);
        if (((scan_res >> 8) & ctrlAlt) == ctrlAlt) {  // ctrl-alt pressed
            event.modifiers &= ~(EVENTFLAG_CONTROL_DOWN | EVENTFLAG_ALT_DOWN);
            event.modifiers |= EVENTFLAG_ALTGR_DOWN;
        }
    }

    browser->GetHost()->SendKeyEvent(event);
}
bool IsMouseEventFromTouch(UINT message, LPARAM extraInfo) {
    #define MOUSEEVENTF_FROMTOUCH 0xFF515700
    return (message >= WM_MOUSEFIRST) && (message <= WM_MOUSELAST) &&
        (extraInfo & MOUSEEVENTF_FROMTOUCH) ==
        MOUSEEVENTF_FROMTOUCH;
}
bool IsOverPopupWidget(int x, int y) {
    return false;
}
void ApplyPopupOffset(int& x, int& y) {}
void DeviceToLogical(CefMouseEvent& e, double f) {}

bool cef_forward_input = true;
HWND game_hwnd = NULL;
WNDPROC game_wndproc_base = nullptr;

static POINT last_mouse_pos_{};
static POINT current_mouse_pos_{};
static bool mouse_rotation_{};
static bool mouse_tracking_{};
static int last_click_x_{}, last_click_y_{};
static CefBrowserHost::MouseButtonType last_click_button_{};
static int last_click_count_{};
static double last_click_time_{};
static bool last_mouse_down_on_view_{};
static double device_scale_factor_ = 1;
static bool use_raw_events_ = false;
const char* GetEventName(UINT message) {
    switch (message) {
        case WM_MOUSEMOVE: return "WM_MOUSEMOVE";
        case WM_LBUTTONDOWN: return "WM_LBUTTONDOWN";
        case WM_LBUTTONUP: return "WM_LBUTTONUP";
        case WM_LBUTTONDBLCLK: return "WM_LBUTTONDBLCLK";
        case WM_RBUTTONDOWN: return "WM_RBUTTONDOWN";
        case WM_RBUTTONUP: return "WM_RBUTTONUP";
        case WM_RBUTTONDBLCLK: return "WM_RBUTTONDBLCLK";
        case WM_MBUTTONDOWN: return "WM_MBUTTONDOWN";
        case WM_MBUTTONUP: return "WM_MBUTTONUP";
        case WM_MBUTTONDBLCLK: return "WM_MBUTTONDBLCLK";
        default: return "?";
    }
}
void OnMouseEvent(UINT message, WPARAM wParam, LPARAM lParam, LONG messageTime, LPARAM extraInfo, bool native) {
    if (IsMouseEventFromTouch(message, extraInfo)) {
        return;
    }
    #if 0
    trace("mouse[%d]: msg=%d/%s wp=(%u %u) lp=(%u %u) xi=%u", messageTime,
        message, GetEventName(message),
        (UINT)wParam >> 16, (UINT)wParam & 0xFFFF, (UINT)lParam >> 16, (UINT)lParam & 0xFFFF, (UINT)extraInfo);
    #endif

    CefRefPtr<CefBrowserHost> browser_host = browser->GetHost();

    LONG currentTime = 0;
    bool cancelPreviousClick = false;

    if (message == WM_LBUTTONDOWN || message == WM_RBUTTONDOWN ||
        message == WM_MBUTTONDOWN || message == WM_MOUSEMOVE ||
        message == WM_MOUSELEAVE) {
        currentTime = messageTime;
        int x = GET_X_LPARAM(lParam);
        int y = GET_Y_LPARAM(lParam);
        cancelPreviousClick =
            (abs(last_click_x_ - x) > (GetSystemMetrics(SM_CXDOUBLECLK) / 2)) ||
            (abs(last_click_y_ - y) > (GetSystemMetrics(SM_CYDOUBLECLK) / 2)) ||
            ((currentTime - last_click_time_) > GetDoubleClickTime());
        if (cancelPreviousClick &&
            (message == WM_MOUSEMOVE || message == WM_MOUSELEAVE)) {
            last_click_count_ = 1;
            last_click_x_ = 0;
            last_click_y_ = 0;
            last_click_time_ = 0;
        }
    }

    switch (message) {
        case WM_LBUTTONDOWN:
        case WM_RBUTTONDOWN:
        case WM_MBUTTONDOWN: {
            if (native) {
                ::SetCapture(game_hwnd);
                ::SetFocus(game_hwnd);
            }
            int x = GET_X_LPARAM(lParam);
            int y = GET_Y_LPARAM(lParam);
            CefBrowserHost::MouseButtonType btnType =
                (message == WM_LBUTTONDOWN
                ? MBT_LEFT
                : (message == WM_RBUTTONDOWN ? MBT_RIGHT : MBT_MIDDLE));
            if (!cancelPreviousClick && (btnType == last_click_button_)) {
                ++last_click_count_;
            } else {
                last_click_count_ = 1;
                last_click_x_ = x;
                last_click_y_ = y;
            }
            last_click_time_ = currentTime;
            last_click_button_ = btnType;

            if (browser_host) {
                CefMouseEvent mouse_event;
                mouse_event.x = x;
                mouse_event.y = y;
                last_mouse_down_on_view_ = !IsOverPopupWidget(x, y);
                ApplyPopupOffset(mouse_event.x, mouse_event.y);
                DeviceToLogical(mouse_event, device_scale_factor_);
                mouse_event.modifiers = client::GetCefMouseModifiers(wParam);
                browser_host->SendMouseClickEvent(mouse_event, btnType, false, last_click_count_);
            }
        } break;

        case WM_LBUTTONUP:
        case WM_RBUTTONUP:
        case WM_MBUTTONUP:
            if (native && GetCapture() == game_hwnd) {
                ReleaseCapture();
            }
            if (mouse_rotation_) {
                // End rotation effect.
                mouse_rotation_ = false;
                //renderHandler->SetSpin(0, 0);
            } else {
                int x = GET_X_LPARAM(lParam);
                int y = GET_Y_LPARAM(lParam);
                CefBrowserHost::MouseButtonType btnType =
                    (message == WM_LBUTTONUP
                    ? MBT_LEFT
                    : (message == WM_RBUTTONUP ? MBT_RIGHT : MBT_MIDDLE));
                if (browser_host) {
                    CefMouseEvent mouse_event;
                    mouse_event.x = x;
                    mouse_event.y = y;
                    //if (last_mouse_down_on_view_ && IsOverPopupWidget(x, y) &&
                    //    (GetPopupXOffset() || GetPopupYOffset())) {
                    //    break;
                    //}
                    ApplyPopupOffset(mouse_event.x, mouse_event.y);
                    DeviceToLogical(mouse_event, device_scale_factor_);
                    mouse_event.modifiers = client::GetCefMouseModifiers(wParam);
                    browser_host->SendMouseClickEvent(mouse_event, btnType, true,
                        last_click_count_);
                }
            }
            break;

        case WM_MOUSEMOVE: {
            int x = GET_X_LPARAM(lParam);
            int y = GET_Y_LPARAM(lParam);
            if (!mouse_tracking_) {
                // Start tracking mouse leave. Required for the WM_MOUSELEAVE event to
                // be generated.
                TRACKMOUSEEVENT tme;
                tme.cbSize = sizeof(TRACKMOUSEEVENT);
                tme.dwFlags = TME_LEAVE;
                tme.hwndTrack = game_hwnd;
                TrackMouseEvent(&tme);
                mouse_tracking_ = true;
            }

            if (browser_host) {
                CefMouseEvent mouse_event;
                mouse_event.x = x;
                mouse_event.y = y;
                ApplyPopupOffset(mouse_event.x, mouse_event.y);
                DeviceToLogical(mouse_event, device_scale_factor_);
                mouse_event.modifiers = client::GetCefMouseModifiers(wParam);
                browser_host->SendMouseMoveEvent(mouse_event, false);
            }
            break;
        }

        case WM_MOUSELEAVE: {
            if (native && mouse_tracking_) {
                // Stop tracking mouse leave.
                TRACKMOUSEEVENT tme;
                tme.cbSize = sizeof(TRACKMOUSEEVENT);
                tme.dwFlags = TME_LEAVE & TME_CANCEL;
                tme.hwndTrack = game_hwnd;
                TrackMouseEvent(&tme);
                mouse_tracking_ = false;
            }

            if (browser_host) {
                // Determine the cursor position in screen coordinates.
                POINT p;
                ::GetCursorPos(&p);
                ::ScreenToClient(game_hwnd, &p);

                CefMouseEvent mouse_event;
                mouse_event.x = p.x;
                mouse_event.y = p.y;
                DeviceToLogical(mouse_event, device_scale_factor_);
                mouse_event.modifiers = client::GetCefMouseModifiers(wParam);
                browser_host->SendMouseMoveEvent(mouse_event, true);
            }
        } break;

        case WM_MOUSEWHEEL: {
            if (browser_host) {
                POINT screen_point = { GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam) };
                if (native) {
                    HWND scrolled_wnd = ::WindowFromPoint(screen_point);
                    if (scrolled_wnd != game_hwnd) {
                        break;
                    }

                    ScreenToClient(game_hwnd, &screen_point);
                }
                int delta = GET_WHEEL_DELTA_WPARAM(wParam);

                CefMouseEvent mouse_event;
                mouse_event.x = screen_point.x;
                mouse_event.y = screen_point.y;
                ApplyPopupOffset(mouse_event.x, mouse_event.y);
                DeviceToLogical(mouse_event, device_scale_factor_);
                mouse_event.modifiers = client::GetCefMouseModifiers(wParam);
                browser_host->SendMouseWheelEvent(mouse_event,
                    client::IsKeyDown(VK_SHIFT) ? delta : 0,
                    !client::IsKeyDown(VK_SHIFT) ? delta : 0);
            }
        } break;
    }
}
struct {
    int x0 = 0, y0 = 0, x1 = 0, y1 = 0;
    WPARAM wParam = 0;
    int nextWheel = 0;
    inline LPARAM lParam() {
        auto ux = (USHORT)(SHORT)x1;
        auto uy = (USHORT)(SHORT)y1;
        return (LPARAM)ux | ((LPARAM)uy << 16);
    }
    bool over = false;
} static state;
dllg void cef_mouse_flag(int rawFlag, int enable) {
    if (enable) {
        state.wParam |= rawFlag;
    } else state.wParam &= ~rawFlag; 
}
dllg bool cef_mouse_event(int kind, int time) {
    if (use_raw_events_) return true;
    UINT mt;
    switch (kind) {
        case 1: mt = WM_LBUTTONDOWN; break;
        case -1: mt = WM_LBUTTONUP; break;
        case 2: mt = WM_RBUTTONDOWN; break;
        case -2: mt = WM_RBUTTONUP; break;
        case 3: mt = WM_MBUTTONDOWN; break;
        case -3: mt = WM_MBUTTONUP; break;
        default: return false;
    }
    WPARAM flag;
    switch (kind < 0 ? -kind : kind) {
        case 1: flag = MK_LBUTTON; break;
        case 2: flag = MK_RBUTTON; break;
        case 3: flag = MK_MBUTTON; break;
        default: return false;
    }
    if (kind < 0) {
        // don't dispatch if we didn't hold the button anyway
        if ((state.wParam & flag) == 0) return true;
        state.wParam &= ~flag;
    } else {
        // don't dispatch if the mouse isn't over the CEF region
        if (!state.over) return true;
        state.wParam |= flag;
    }
    OnMouseEvent(mt, state.wParam, state.lParam(), time, 0, false);
    return true;
}
dllg bool cef_mouse_move(int nx, int ny, int time, bool canmouseover) {
    if (use_raw_events_) return true;
    state.x0 = state.x1;
    state.y0 = state.y1;
    state.x1 = nx;
    state.y1 = ny;
    auto wasOver = state.over;
    state.over = canmouseover && nx >= 0 && ny >= 0 && nx < renderHandler->m_width && ny < renderHandler->m_height;
    if ((state.over || wasOver
        || (state.wParam & (MK_LBUTTON | MK_RBUTTON | MK_MBUTTON)) != 0
    ) && (state.x0 != state.x1 || state.y0 != state.y1)) {
        OnMouseEvent(WM_MOUSEMOVE, state.wParam, state.lParam(), time, 0, false);
    }
    if (state.nextWheel != 0) {
        auto wParam = (((WPARAM)(USHORT)(SHORT)state.nextWheel) << 16) | state.wParam;
        state.nextWheel = 0;
        OnMouseEvent(WM_MOUSEWHEEL, wParam, state.lParam(), time, 0, false);
    }
    return true;
}

LRESULT game_wndproc_hook(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam) {
    if (cef_forward_input) switch (message) {
        case WM_KEYDOWN: case WM_KEYUP: case WM_CHAR:
        case WM_SYSKEYDOWN: case WM_SYSKEYUP: case WM_SYSCHAR: {
            OnKeyEvent(message, wParam, lParam);
        }; break;
        case WM_LBUTTONDOWN:
        case WM_RBUTTONDOWN:
        case WM_MBUTTONDOWN:
        case WM_LBUTTONUP:
        case WM_RBUTTONUP:
        case WM_MBUTTONUP:
        case WM_MOUSEMOVE:
        case WM_MOUSELEAVE:
        case WM_MOUSEWHEEL:
            if (use_raw_events_) {
                OnMouseEvent(message, wParam, lParam, GetMessageTime(), GetMessageExtraInfo(), true);
            } else if (message == WM_MOUSEWHEEL) {
                state.nextWheel = GET_WHEEL_DELTA_WPARAM(wParam);
            }
            break;
    }
    return CallWindowProc(game_wndproc_base, hwnd, message, wParam, lParam);
}

///
dllx double cef_get_focus() {
    return game_wndproc_base != nullptr && cef_forward_input;
}
///
dllx double cef_set_focus(double enable) {
    cef_forward_input = enable > 0.5;
    if (cef_forward_input && game_wndproc_base == nullptr) {
        game_wndproc_base = (WNDPROC)SetWindowLongPtr(game_hwnd, GWLP_WNDPROC, (LONG_PTR)game_wndproc_hook);
    }
    browser->GetHost()->SetFocus(cef_forward_input);
    return true;
}#include "cefgml.h"

void RenderHandler::GetViewRect(CefRefPtr<CefBrowser> _browser, CefRect& rect) {
    rect = CefRect(0, 0, m_width, m_height);
}
void RenderHandler::OnPaint(CefRefPtr<CefBrowser> _browser, PaintElementType type, const RectList& dirtyRects, const void* buffer, int width, int height) {
    if (width != m_width || height != m_height) {
        // excuse you, why
        return;
    }
    if (m_rgba) {
        auto count = width * height;
        m_needsRedraw = true;
        #if 0
        auto rgba = (uint32_t*)buffer;
        std::transform(std::execution::par_unseq,
            rgba, rgba + count, (uint32_t*)m_rgba,
            [](uint32_t px) -> uint32_t {
                return (px & 0xFF00FF00u)
                    | ((px & 0x00FF0000u) >> 16)
                    | ((px & 0x000000FFu) << 16);
            });
        #else
        memcpy(m_rgba, buffer, count * 4);
        #endif
    }
}#include <windows.h>

#include "include/cef_command_line.h"
#include "include/cef_sandbox_win.h"
#include "tests/cefsimple/simple_app.h"

#if defined(CEF_USE_SANDBOX)
// The cef_sandbox.lib static library may not link successfully with all VS
// versions.
#pragma comment(lib, "cef_sandbox.lib")
#endif

// Entry point function for all processes.
int APIENTRY wWinMain(HINSTANCE hInstance,
    HINSTANCE hPrevInstance,
    LPTSTR lpCmdLine,
    int nCmdShow) {
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

    #if defined(ARCH_CPU_32_BITS)
    #error TODO: figure out what is supposed to happen here https://bitbucket.org/chromiumembedded/cef/wiki/GeneralUsage#markdown-header-separate-sub-process-executable
    // Run the main thread on 32-bit Windows using a fiber with the preferred 4MiB
    // stack size. This function must be called at the top of the executable entry
    // point function (`main()` or `wWinMain()`). It is used in combination with
    // the initial stack size of 0.5MiB configured via the `/STACK:0x80000` linker
    // flag on executable targets. This saves significant memory on threads (like
    // those in the Windows thread pool, and others) whose stack size can only be
    // controlled via the linker flag.
    exit_code = CefRunWinMainWithPreferredStackSize(wWinMain, hInstance,
        lpCmdLine, nCmdShow);
    if (exit_code >= 0) {
        // The fiber has completed so return here.
        return exit_code;
    }
    #endif

    void* sandbox_info = nullptr;

    #if defined(CEF_USE_SANDBOX)
    // Manage the life span of the sandbox information object. This is necessary
    // for sandbox support on Windows. See cef_sandbox_win.h for complete details.
    CefScopedSandboxInfo scoped_sandbox;
    sandbox_info = scoped_sandbox.sandbox_info();
    #endif

    #ifndef _WINDOWS
    // TODO: is /include/wrapper/cef_library_loader.h mac-exclusive? Why isn't it in distro
    // Load the CEF framework library at runtime instead of linking directly
    // as required by the macOS sandbox implementation.
    CefScopedLibraryLoader library_loader;
    if (!library_loader.LoadInHelper()) return 1;
    #endif

    // Provide CEF with command-line arguments.
    CefMainArgs main_args(hInstance);

    // CEF applications have multiple sub-processes (render, GPU, etc) that share
    // the same executable. This function checks the command-line and, if this is
    // a sub-process, executes the appropriate logic.
    return CefExecuteProcess(main_args, nullptr, sandbox_info);
}#include <windows.h>

#include "include/cef_command_line.h"
#include "include/cef_sandbox_win.h"
#include "tests/cefsimple/simple_app.h"
#include "tests/shared/browser/util_win.h"
#include <algorithm>
#include <execution>
#include <locale>
#include <codecvt>

#include <windowsx.h>

#include "gml_ext.h"
#include "cefgml.h"

// GameMaker strings are UTF8, but that's not what CEF expects for Windows strings
class StringConv {
public:
    LPSTR cbuf = NULL;
    size_t cbuf_size = 0;
    LPWSTR wbuf = NULL;
    size_t wbuf_size = 0;
    StringConv() {

    }
    void init() {
        cbuf = nullptr;
        cbuf_size = 0;
        wbuf = nullptr;
        wbuf_size = 0;
    }
    LPWSTR wget(size_t size) {
        if (wbuf_size < size) {
            wbuf = (wchar_t*)realloc(wbuf, sizeof(wchar_t) * size);
            wbuf_size = size;
        }
        return wbuf;
    }
    LPCWSTR proc(const char* src, int cp = CP_UTF8) {
        size_t size = MultiByteToWideChar(cp, 0, src, -1, NULL, 0);
        auto buf = wget(size);
        MultiByteToWideChar(cp, 0, src, -1, buf, (int)size);
        return buf;
    }
    LPSTR get(size_t size) {
        if (cbuf_size < size) {
            cbuf = (char*)realloc(cbuf, size);
            cbuf_size = size;
        }
        return cbuf;
    }
    LPCSTR proc(LPCWSTR src, int cp = CP_UTF8) {
        size_t size = WideCharToMultiByte(cp, 0, src, -1, NULL, 0, NULL, NULL);
        char* buf = get(size);
        WideCharToMultiByte(cp, 0, src, -1, buf, (int)size, NULL, NULL);
        return buf;
    }
} strconv;

RenderHandler* renderHandler{};
CefRefPtr<BrowserClient> browserClient{};
CefRefPtr<CefBrowser> browser{};
CefRefPtr<CefApp> appPtr{};
extern HWND game_hwnd;

dllx double cef_set_size_raw(double width, double height, uint8_t* buffer) {
    if (!renderHandler) return false;
    auto newWidth = (int)width;
    auto newHeight = (int)height;
    auto resized = renderHandler->m_width != newWidth || renderHandler->m_height != newHeight;
    renderHandler->m_width = newWidth;
    renderHandler->m_height = newHeight;
    renderHandler->m_rgba = buffer;
    renderHandler->m_needsRedraw = false;
    if (resized) browser->GetHost()->WasResized();
    return true;
}

dllx double cef_update_raw() {
    if (!renderHandler) return false;
    CefDoMessageLoopWork();
    return true;
}

dllx double cef_needs_redraw() {
    if (!renderHandler || !renderHandler->m_needsRedraw) return false;
    renderHandler->m_needsRedraw = false;
    return true;
}
///
dllx const char* cef_get_address() {
    static std::string result{};
    auto frame = browser->GetMainFrame();
    if (frame) {
        result = frame->GetURL().ToString();
    } else result = "";
    return result.c_str();
}
///
dllx double cef_set_address(const char* url) {
    auto frame = browser->GetMainFrame();
    if (frame) {
        frame->LoadURL(url);
        return true;
    }
    return false;
}

dllx const char* cef_get_build_time() {
    static std::string s = std::string(__DATE__) + " " + __TIME__;
    return s.c_str();
}

std::optional<std::wstring> cef_cache_path = {};
///
dllx double cef_set_cache_path(const char* path) {
    cef_cache_path = strconv.proc(path);
    return true;
}

std::optional<bool> cef_persist_session_cookies = {};
///
dllx double cef_set_persist_session_cookies(double set) {
    cef_persist_session_cookies = set > 0.5;
    return true;
}

dllx double cef_init_raw(double _width, double _height, void* _hwnd, const char* _url) {
    game_hwnd = (HWND)_hwnd;
    if (renderHandler) return -4;
    void* sandbox_info = nullptr;

    #if defined(CEF_USE_SANDBOX)
    // Manage the life span of the sandbox information object. This is necessary
    // for sandbox support on Windows. See cef_sandbox_win.h for complete details.
    CefScopedSandboxInfo scoped_sandbox;
    sandbox_info = scoped_sandbox.sandbox_info();
    #endif

    CefMainArgs main_args(GetModuleHandle(NULL));

    CefSettings settings;
    #if !defined(CEF_USE_SANDBOX)
    settings.no_sandbox = true;
    #endif

    // https://stackoverflow.com/a/6924332/5578773
    HMODULE dllModule;
    if (GetModuleHandleExW(
        GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
        (LPCWSTR)&cef_init_raw, &dllModule
        ) == 0) {
        printf("[cefgml] GetModuleHandleEx failed, error %d", GetLastError());
        fflush(stdout);
        return false;
    }
    wchar_t dllPath[MAX_PATH];
    if (GetModuleFileNameW(dllModule, dllPath, (DWORD)std::size(dllPath)) == 0) {
        printf("[cefgml] GetModuleFileName failed, error %d", GetLastError());
        fflush(stdout);
        return false;
    }

    // change .dll to .exe in the end of it:
    auto extAt = wcslen(dllPath) - 3;
    dllPath[extAt++] = L'e';
    dllPath[extAt++] = L'x';
    dllPath[extAt++] = L'e';
    CefString(&settings.browser_subprocess_path).FromWString(dllPath);


    if (cef_cache_path.has_value()) {
        CefString(&settings.cache_path).FromWString(cef_cache_path.value());
    }
    if (cef_persist_session_cookies.has_value()) {
        settings.persist_session_cookies = cef_persist_session_cookies.value();
    }

    // Initialize CEF.
    auto ok = CefInitialize(main_args, settings, nullptr, sandbox_info);
    if (!ok) return -1;

    renderHandler = new RenderHandler((int)_width, (int)_height);

    CefWindowInfo windowInfo{};
    windowInfo.SetAsWindowless(nullptr);

    CefBrowserSettings browserSettings{};

    browserClient = new BrowserClient(renderHandler);

    browser = CefBrowserHost::CreateBrowserSync(windowInfo, browserClient, _url, browserSettings, nullptr, nullptr);

    return 1;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
    return TRUE;
}