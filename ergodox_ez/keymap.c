// How to build:
//
//   0. Modify $DEBOUNCE macro variable to proper value
//      (currenctly setting 18) in config.h
//   1. Link this file to keyboards/ergodox_ez/keymaps/rhysd/keymap.c
//   2. Compile it with the following command:
//
//   $ make ergodox_ez:rhysd:teensy KEYMAP=rhysd SLEEP_LED_ENABLE=no
//
// 3. Load hex file with teensy loader
//
//   $ teensy_loader_cli -mmcu=atmega32u4 -w ergodox_ez_rhysd.hex
//
// Ref: https://rhysd.hatenablog.com/entry/2016/08/29/090105
//
// Netable differences vs. the default firmware for the ErgoDox EZ:
// 1. The Cmd key is now on the right side, making Cmd+Space easier.
// 2. The media keys work on OSX (But not on Windows).
//
// clang-format off
#include QMK_KEYBOARD_H
#include "debug.h"
#include "action_layer.h"

#define BASE 0 // default layer
#define SYMB 1 // symbols
#define MDIA 2 // media keys

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
/* Keymap 0: Basic layer
 *
 * ,---------------------------------------------------.           ,----------------------------------------------------.
 * | ESC    |   1  |   2  |   3  |   4   |   5  |  6   |           |      |   7  |   8   |   9  |   0  |   -  |   =     |
 * |--------+------+------+------+-------+-------------|           |------+------+-------+------+------+------+---------|
 * | Tab    |   Q  |   W  |   E  |   R   |   T  |  {   |           |  _   |   Y  |   U   |   I  |   O  |   P  |   \     |
 * |--------+------+------+------+-------+------|      |           |      |------+-------+------+------+------+---------|
 * | LCtrl  |   A  |   S  |   D  |   F   |   G  |------|           |------|   H  |   J   |   K  |   L  |   ;  |  '"     |
 * |--------+------+------+------+-------+------|  }   |           |  =   |------+-------+------+------+------+---------|
 * | LShift |   Z  |   X  |   C  |   V   |   B  |      |           |      |   N  |   M   |   ,  |   .  |   /  |  `      |
 * `--------+------+------+------+-------+-------------'           `-------------+-------+------+------+------+---------'
 *   |C-Left|      |      | LAlt |LG/Eisu|                                       |RG/Kana| RAlt |   [  |   ]  |C-Right|
 *   `-----------------------------------'                                       `------------------------------------'
 *                                     ,---------------.           ,---------------.
 *                                     |LGuiEnt|LGuiSpc|           |AltTab|LGuiSpc |
 *                              ,------|-------|-------|           |------+--------+--------.
 *                              |      |       | Home  |           | PgUp |        |        |
 *                              |Ctrl/ |TapL1/ |-------|           |------|BackSpc |RShift/ |
 *                              |Space |Tab    | End   |           | PgDn |        |Enter   |
 *                              `----------------------'           `----------------------'
 */
// If it accepts an argument (i.e, is a function), it doesn't need KC_.
// Otherwise, it needs KC_*
[BASE] = LAYOUT_ergodox(  // layer 0 : default
        // left hand
        KC_ESC,       KC_1,    KC_2,   KC_3,   KC_4,   KC_5,   KC_6,
        KC_TAB,       KC_Q,    KC_W,   KC_E,   KC_R,   KC_T,   KC_LCBR,
        KC_LCTRL,     KC_A,    KC_S,   KC_D,   KC_F,   KC_G,
        KC_LSFT,      KC_Z,    KC_X,   KC_C,   KC_V,   KC_B,   KC_RCBR,
        LCTL(KC_LEFT),KC_TRNS, KC_TRNS,KC_LALT,GUI_T(KC_LANG2),
                                                            LGUI(KC_ENT),   LGUI(KC_SPC),
                                                                            KC_HOME,
                                              CTL_T(KC_SPC),LT(SYMB,KC_TAB),KC_END,
        // right hand
        KC_TRNS,     KC_7,           KC_8,   KC_9,   KC_0,   KC_MINS,KC_EQL,
        KC_UNDS,     KC_Y,           KC_U,   KC_I,   KC_O,   KC_P,   KC_BSLS,
                     KC_H,           KC_J,   KC_K,   KC_L,   KC_SCLN,KC_QUOT,
        KC_EQL,      KC_N,           KC_M,   KC_COMM,KC_DOT, KC_SLSH,KC_GRV,
                     GUI_T(KC_LANG1),KC_RALT,KC_LBRC,KC_RBRC,LCTL(KC_RGHT),
        LALT(KC_TAB),LGUI(KC_SPC),
        KC_PGUP,
        KC_PGDN,     KC_BSPC,SFT_T(KC_ENT)
    ),
/* Keymap 1: Symbol Layer
 *
 * ,--------------------------------------------------.           ,--------------------------------------------------.
 * |        |  F1  |  F2  |  F3  |  F4  |  F5  |  F6  |           |      |      |      |  -   |  =   |  \   |   `    |
 * |--------+------+------+------+------+-------------|           |------+------+------+------+------+------+--------|
 * |        |  F7  |  F8  |  F9  |  F10 |  F11 |  F12 |           |      |      |      | Home |      |   [  |   ]    |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |   {  |   }  |   (  |   )  |   `  |------|           |------| Left | Down | Up   |Right |      |        |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |   <  |   >  |   [  |   ]  |   ~  |      |           |      |      | End  |      |      |      |   _    |
 * `--------+------+------+------+------+-------------'           `-------------+------+------+------+------+--------'
 *   |      | Play | Mute |VolDn |VolUp |                                       |      |      |      |      |      |
 *   `----------------------------------'                                       `----------------------------------'
 *                                        ,-------------.       ,-------------.
 *                                        |      |      |       |      |      |
 *                                 ,------|------|------|       |------+------+------.
 *                                 |      |      |      |       |      |      |      |
 *                                 |      |      |------|       |------|      |      |
 *                                 |      |      |      |       |      |      |      |
 *                                 `--------------------'       `--------------------'
 */
// SYMBOLS
[SYMB] = KEYMAP(
       // left hand
       KC_TRNS,KC_F1,  KC_F2,  KC_F3,  KC_F4,  KC_F5,  KC_F6,
       KC_TRNS,KC_F7,  KC_F8,  KC_F9,  KC_F10, KC_F11, KC_F12,
       KC_TRNS,KC_LCBR,KC_RCBR,KC_LPRN,KC_RPRN,KC_GRV,
       KC_TRNS,KC_LABK,KC_RABK,KC_LBRC,KC_RBRC,KC_TILD,KC_TRNS,
       KC_TRNS,KC_MPLY,KC_MUTE,KC_VOLD,KC_VOLU,
                                       KC_TRNS,KC_TRNS,
                                               KC_TRNS,
                               KC_TRNS,KC_TRNS,KC_TRNS,
       // right hand
       KC_TRNS, KC_TRNS, KC_TRNS,KC_MINS, KC_EQL,  KC_BSLS, KC_GRV,
       KC_TRNS, KC_TRNS, KC_TRNS,KC_HOME, KC_TRNS, KC_LBRC, KC_RBRC,
                KC_LEFT, KC_DOWN,KC_UP,   KC_RIGHT,KC_TRNS, KC_TRNS,
       KC_TRNS, KC_TRNS, KC_END, KC_TRNS, KC_TRNS, KC_TRNS, KC_UNDS,
                         KC_TRNS,KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
       KC_TRNS,KC_TRNS,
       KC_TRNS,
       KC_TRNS,KC_TRNS, KC_TRNS
),
/* Keymap 2: Media and mouse keys
 *
 * ,--------------------------------------------------.           ,--------------------------------------------------.
 * |        |      |      |      |      |      |      |           |      |      |      |      |      |      |        |
 * |--------+------+------+------+------+-------------|           |------+------+------+------+------+------+--------|
 * |        |      |      | MsUp |      |      |      |           |      |      |      |      |      |      |        |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |      |MsLeft|MsDown|MsRght|      |------|           |------|      |      |      |      |      |  Play  |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |      |      |      |      |      |      |           |      |      |      | Prev | Next |      |        |
 * `--------+------+------+------+------+-------------'           `-------------+------+------+------+------+--------'
 *   |      |      |      | Lclk | Rclk |                                       |VolUp |VolDn | Mute |      |      |
 *   `----------------------------------'                                       `----------------------------------'
 *                                        ,-------------.       ,-------------.
 *                                        |      |      |       |      |      |
 *                                 ,------|------|------|       |------+------+------.
 *                                 |      |      |      |       |      |      |Brwser|
 *                                 |      |      |------|       |------|      |Back  |
 *                                 |      |      |      |       |      |      |      |
 *                                 `--------------------'       `--------------------'
 */
// MEDIA AND MOUSE
[MDIA] = KEYMAP(
       KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
       KC_TRNS, KC_TRNS, KC_TRNS, KC_MS_U, KC_TRNS, KC_TRNS, KC_TRNS,
       KC_TRNS, KC_TRNS, KC_MS_L, KC_MS_D, KC_MS_R, KC_TRNS,
       KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
       KC_TRNS, KC_TRNS, KC_TRNS, KC_BTN1, KC_BTN2,
                                           KC_TRNS, KC_TRNS,
                                                    KC_TRNS,
                                  KC_TRNS, KC_TRNS, KC_TRNS,
    // right hand
       KC_TRNS,  KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
       KC_TRNS,  KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
                 KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_MPLY,
       KC_TRNS,  KC_TRNS, KC_TRNS, KC_MPRV, KC_MNXT, KC_TRNS, KC_TRNS,
                          KC_VOLU, KC_VOLD, KC_MUTE, KC_TRNS, KC_TRNS,
       KC_TRNS, KC_TRNS,
       KC_TRNS,
       KC_TRNS, KC_TRNS, KC_WBAK
),
};

const uint16_t PROGMEM fn_actions[] = {
    [1] = ACTION_LAYER_TAP_TOGGLE(SYMB)                // FN1 - Momentary Layer 1 (Symbols)
};

const macro_t *action_get_macro(keyrecord_t *record, uint8_t id, uint8_t opt)
{
  // MACRODOWN only works in this function
      switch(id) {
        case 0:
        if (record->event.pressed) {
          register_code(KC_RSFT);
        } else {
          unregister_code(KC_RSFT);
        }
        break;
      }
    return MACRO_NONE;
};

// Runs just one time when the keyboard initializes.
void matrix_init_user(void) {
#ifdef RGBLIGHT_COLOR_LAYER_0
  rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
#endif
};

// Runs constantly in the background, in a loop.
void matrix_scan_user(void) {

};

// Runs whenever there is a layer state change.
uint32_t layer_state_set_user(uint32_t state) {
  ergodox_board_led_off();
  ergodox_right_led_1_off();
  ergodox_right_led_2_off();
  ergodox_right_led_3_off();

  uint8_t layer = biton32(state);
  switch (layer) {
      case 0:
        #ifdef RGBLIGHT_COLOR_LAYER_0
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
        #else
        #ifdef RGBLIGHT_ENABLE
          rgblight_init();
        #endif
        #endif
        break;
      case 1:
        ergodox_right_led_1_on();
        #ifdef RGBLIGHT_COLOR_LAYER_1
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_1);
        #endif
        break;
      case 2:
        ergodox_right_led_2_on();
        #ifdef RGBLIGHT_COLOR_LAYER_2
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_2);
        #endif
        break;
      case 3:
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_3
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_3);
        #endif
        break;
      case 4:
        ergodox_right_led_1_on();
        ergodox_right_led_2_on();
        #ifdef RGBLIGHT_COLOR_LAYER_4
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_4);
        #endif
        break;
      case 5:
        ergodox_right_led_1_on();
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_5
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_5);
        #endif
        break;
      case 6:
        ergodox_right_led_2_on();
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_6
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_6);
        #endif
        break;
      case 7:
        ergodox_right_led_1_on();
        ergodox_right_led_2_on();
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_7
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_6);
        #endif
        break;
      default:
        break;
    }

  return state;
};
