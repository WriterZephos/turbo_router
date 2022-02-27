# TurboRouter

TurboRouter is a simple Rails plugin that smooths over some of the complexity and inconsistencies of using turbo-frames. For example, it can be a bit frustrating to understand or predict how turbo enabled links will behave, especiallyy when you are just learning how to use them. This is because they can have several different attributes that can change their behavior, and their location in the context of the DOM can also change what they do.

To make things just a little easier, TurboRouter provides a handfull of straightforward view helpers that wrap the standard Rails `link_to` helper and set the proper attributes on the links they generate so they will have a consistant and predictable behavior, regardless of where they are in the DOM and without the need to set different attributes. They also make it more straightforward to know when the browser's history will be advanced, and when it will not be.

Another aspect of turbo_frames that TurboRouter remedies is the fact that you need to wrap the HTML templates rendered back from your controllers with a turbo_frame matching the part of the DOM you wish to replace. Doing this may limit the reusability and flexibility of your templates, and it is extra boiler plate code that can easily be abstracted away. TurboRouter does this by rendering your templates with a layout with a dynamic id set to match the targeted turbo_frame of the request, so the partials always render with the proper turbo_frame wrapper. This behavior is, of course, opt-in for each controller action, so that you are not forced to use the dynamic template when you do not what to, but it is there when you need it.

TurboRouter establishes a baseline for turbo enabled links by wrapping the `<%= yield %>` in your `application.html.erb` with a turbo_frame (using a partial) with `id="turbo_router_content"`. By default, links generated by TurboRouter view helpers that don't target the entire page, will target this turbo_frame. Of course, you can set the `data-turbo-frame` attribute on these links just as you would with `link_to` to target a different turbo_frame instead.

TurboRouter also provides a method to your controllers for rendering a turbo_stream that targets the default turbo_frame, but can accept a different `id` as well

In short, TurboRouter turns the following table:

<img width="1134" alt="Screen Shot 2022-02-24 at 8 47 24 PM" src="https://user-images.githubusercontent.com/11528362/155743029-4888afbf-847c-44b2-98ab-e4b7a50f2197.png">

Into this:

<img width="1133" alt="Screen Shot 2022-02-24 at 8 47 38 PM" src="https://user-images.githubusercontent.com/11528362/155743143-b3159932-1877-4a98-905f-b56a84b5dca0.png">

The above tables may not look that different, and they are not. This plugin simply provides a slightly different API that is more imperative and requires setting fewer attributes yourself and less boiler plate code in your templates. It certainly isn't necessary, but it might be nice to have for those that find it useful.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "turbo_router"
```

And then execute:
```bash
$ bundle
```

Then run:
```bash
rails generate turbo_router
```

The above command will create the following files in your app:

* app/views/layouts/_turbo_router_content.erb
* app/views/layouts/turbo_router_content.erb

The above command will also wrap the `yield` call in `application.html.erb` with the `layouts/turbo_router_content` partial layout like so:

```ruby
  <%= render "layouts/turbo_router_content" do %><%= yield %><% end %>
```

The above layout ultimately wraps its contents with a turbo frame with `id="turbo_router_content"` which will serve as the target for all TurboRouter navigations that do not target the full page.

## Usage

### Controllers
Simply add this line to your `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  include TurboRouter::Controller
```

For any actions you wish to render using the dynamic turbo_frame template, simply call `use_dynamic_layout` and pass those actions to it like so:

```ruby
  use_dynamic_layout :index, :show
```

When an action is passed to `use_dynamic_layout` and when requests are turbo_frame requests (`turbo_frame_request?` returns `true`), the layout rendered will wrap the template in a turbo_frame with the id matching `request.headers["Turbo-frame"]`. This is always the same value that is set on the `data-turbo-frame` attribute on the link that initiated the request (or the containing turbo_frame's id if not set). TurboRouter view helpers ensure that this value is always set to either `turbo_router_content` if it isn't already set.

By default, if a request does not use the dynamic layout, the application layout will be used.

Because TurboRouter sets the controller's layout to use its dynamic layout for turbo_frame requests, it is incompatible with setting a different static/ global layout for a controller for other types of requests (turbo-rails also has this problem, but offers no solution). TurboRouter, however, allows you to set a layout for all requests that are not turbo_frame requests without interfering with the dynamic layout behavior using the `page_layout` method, like so:

```ruby
class ChaptersController < ApplicationController
  page_layout :other_layout
```

Of course, you are still able to set a layout more granularly with individual calls to render by passing a layout parameter, in which case the provided layout will override any layout that was determined by other means.

TurboRouter provides an additional method for controllers, `turbo_router_stream`, which simply reduces the amount of boilerplat code you have to write to render a turbo_stream. It takes a template as it's first argument, and an optional id for the target element which defaults to `turbo_router_content` if not provided, and any other options to be passed to as locals to the render call. Use it like so:

```ruby
    respond_to do |format|
      format.turbo_stream do
        turbo_router_stream "posts/show", "post_container", post: @post
      end
    end
```

### View Helpers

The view helper TurboRouter provides are:

* `turbo_router_load_to`
* `turbo_router_link_to`
* `turbo_router_render_to`
* `turbo_router_route_to`.

The helpers `turbo_router_load_to` and `turbo_router_link_to` both target the entire page, but the former performs a full page load without using TurboDrive, while the latter utilizes TurboDrive (under the hood it uses `data-turbo-frame="_top"`). Both of these links will advance the browser's history.

The helpers `turbo_router_render_to` and `turbo_router_route_to` both target a turbo_frame (either the default turbo_frame with `id="turbo_router_content"` or a different one specified with `data-turbo-frame`), but the former does not advance the browser's history while the latter does.

All of the view helpers have take the same signature as `link_to` so you may still pass any other attributes such as `class` or other `data` attributes as well (certain data attributes will be overridend to achieve the required behavior). This means they can directly replace any `link_to` calls you have in your views and they will continue to work as expected in all other ways, but with the more imperatively determined behavior described above.

## Contributing
### This plugin is currently in it's alpha stage and contributors are welcome!

Things that need to be done:

* Add helpers for button_to perhaps.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
