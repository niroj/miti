## [Unreleased]

## [1.3.0] - 2026-10-23

### Rails integration
- Add `nepali_date_range_field` form helper: one input with a single popover for drag-to-select or click-to-select, range highlighting, and two hidden inputs. Fires a `miti:range-selected` event
- Add a CSS variable theming system with built-in themes (`light`, `dark`, `indigo`, `midnight`, `tokyo_night`, `nord`), plus a `theme:` option on form helpers and `data-miti-theme` on any ancestor
- Dark theme auto-detects `prefers-color-scheme: dark`; opt out with `data-miti-theme-auto="false"`
- Add `Miti::Rails::ControllerConcern` with `auto_convert_bs_dates` (converts BS date params to AD on every action; accepts `only:`/`except:`) and a `parse_date_param` helper
- Add `CalendarDataController` JSON endpoint for picker calendar data
- Add `miti_assets` view helper for one-line asset inclusion
- Add importmap pin declarations for miti JS modules
- Add `store_bs: true` option to `has_nepali_date`, plus a `rails generate miti:store_bs Model attribute` generator that adds the migration and wires up the model
- `nepali_date_field` now submits the BS string directly; the custom attribute type converts it to AD on assignment
- `has_nepali_date` with `store_bs` syncs the BS column to AD in `before_validation`
- Install generator suggests `--copy-styles` when a JS bundler is detected

### JavaScript
- Extract `MitiDatePicker` as a standalone class with a cleanup API; the Stimulus controller delegates to it
- Add an auto-initializing entry point for bundler (esbuild/webpack/rollup/vite) setups
- Load calendar data asynchronously, with a fetch fallback and a `localStorage` cache
- Add `toNepaliDigits()` and `formatBsNepali()` helpers to `MitiConverter`

### Core
- Add tokenized formatting via `NepaliDate#format` (e.g. `format("%B %g, %Y %A", nepali: true)`)

### Breaking changes
- Calendar data endpoint changed from `GET` to `POST`. CSRF verification is skipped for this action
- `nepali_date_field` no longer renders a hidden AD input. Params now carry the BS string, so update any code that read the old AD param
- Install generator no longer pins importmap or injects Sprockets requires. It adds `import "miti"` to `app/javascript/application.js` and a `stylesheet_link_tag` to the layout
- `StoreBs` no longer uses a `before_save` callback; syncing now happens in the setter and in `before_validation`
- Remove `Formatter.to_s` and `Formatter.descriptive` class methods (they raised `NameError` when called)

### Bug fixes
- **Security:** validate `miti:store_bs` generator arguments to prevent path traversal and glob injection
- Fix date picker close behavior: replace the blur/mousedown race with a document click listener
- Fix double initialization when both Stimulus and auto-init are active
- Fix `@hotwired/stimulus` resolution for both importmap and esbuild setups
- Fix bundler auto-detection to prefer bundler mode when esbuild/webpack/rollup/vite is present
- Fix `copy_javascript_files` failing from an installed gem path
- Fix `store_bs` generator migrations: drop hard-coded `Migration[7.1]` (Rails < 7.1 compat), add the version bracket, and use the absolute `::ActiveRecord` namespace
- Fix `store_bs` and install generator `destroy`/revoke not removing files and injected code
- Fix BS→AD type cast returning `Date.parse` output on failure; it now returns `nil`
- Narrow the `rescue` in `convert_to_nepali` from `StandardError` to specific error classes
- Fix `%B` short form missing from the formatter's legacy token group
- Guard the `ActiveRecord` require so Rails apps without ActiveRecord can load miti

### Other
- Gemspec now includes the `config/` and `app/controllers/` directories
- Document the theme API and formatter usage; fix stale examples in `docs/`
- Rubocop cleanup and `frozen_string_literal` annotations

## [1.2.0] - 2026-05-14

### Rails integration
- Add `Miti::Engine` (Rails Engine) for auto-exposing `app/assets` paths
- Add `nepali_calendar` helper for monthly grid view with Turbo Frame nav
- Add `nepali_calendar_agenda` helper for agenda/list view grouped by week or month
- Add `nepali_date_field` form helper with Stimulus-powered popover date picker
- Add `nepali_date_select` form helper with 3-dropdown BS date selector
- Add `has_nepali_date` model concern for AD↔BS auto-conversion on ActiveRecord attributes
- Add `include_miti_date_picker_data` helper for injecting calendar data into layouts
- Add `Miti::Rails::Calendar::DayPresenter` for calendar/agenda view blocks
- Add `rails generate miti:install` generator with auto-detection of importmap vs esbuild; `--copy-javascript` and `--copy-styles` flags
- Add Stimulus date picker controller with day/month/year grid views and adaptive positioning
- Add `converter.js` — BS↔AD conversion engine as ES module
- Add calendar.css with theming via CSS custom properties (`--miti-*`)
- Add `value:` parameter support to `nepali_date_field` for default values
- Move controller from input to wrapper for calendar icon button support
- Add hover effects, smaller input sizing, and calendar icon to date field
- Calendar title now shows English month abbreviation range in brackets, e.g. `Baisakh (Apr-May) 2083`, styled non-bold/italic

### Breaking changes
- **Ruby minimum raised to 3.1** (from 3.0)
- Month name constants renamed: `Baishakh` → `Baisakh`, `वैशाख` → `बैशाख`
- Error classes refactored into `Miti::NepaliDate::FormatError`, `Miti::NepaliDate::DateRangeError`
- `to_s` refactored into `Miti::NepaliDate::Formatter`
- `NepaliDate` parsing extracted into `Miti::NepaliDate::Parser`
- Date validation extracted into `Miti::NepaliDate::Validator`
- Date comparison extracted into `Miti::NepaliDate::Comparison`
- Date difference extracted into `Miti::NepaliDate::Difference`

### Bug fixes
- Fix `turbo_frame_tag` content not rendering — use block form instead of positional argument (turbo-rails uses `*ids` splat)
- Fix rubocop offenses (ABC size, unused kw args, module length)

### Dev & CI
- Bump development Ruby to 4.0.3
- Bump `required_ruby_version` to `>= 3.1, < 5.0`
- Update CI to test Ruby 3.1, 3.4, and 4.0
- Update rubocop configurations and fix all offenses

## [1.1.0] - 2025-01-01

- Fix bug in `parse_nepali_date` where passing a `Miti::NepaliDate` object raised an error
- Fix stray closing brace in `descriptive(nepali: true)` output
- Add comprehensive test coverage for `BsToAd`, `NepaliDate`, and integration specs
- Bump minimum Ruby version to 3.0
- Update CI to test against Ruby 3.0–3.4 and use actions/checkout@v4
- Update Rubocop config (target 3.0, correct date_data path, relaxed MethodLength)

## [1.0.1] - 2023-07-01
- add gem dependency thor
- Update documentation for CLI app usage and readme.md

## [1.0.0] - 2023-06-27
- New release 1.0.0
- Integrate Miti CLI
- Miti CLI now accepts arguments for date conversion

## [0.1.0] - 2023-05-21
- Change Class method to constant for fetching date. Add corresponding date for Baisakh 1 and Jan 1.
- Simplify logic for AD to BS conversion
- Refactor and add comments

## [0.0.1] - 2022-09-24

- Initial release
