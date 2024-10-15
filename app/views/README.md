### Some helpful information to know before you add your frontend changes

- If you are adding HTML that will be common across the website (i.e on all pages), please introduce those changes into `application.html.erb`.
- The `yield` keyword you'll see is the space where you're individual page content will be placed
- For some pages which follow a different HTML format, specify the same in the `layouts` folder and name the file according to the page. For example, in our case, the login page has a similar but different navbar compared to the remaining pages. Hence we have defined a `login.html.erb` in the `layouts` folder.
- You can add the CSS at `assets/stylesheets`. Be careful on the naming convention of the classes or how you are specifying the specificity, as it could effect the other pages.
- If you specify something like `<%= yield :head %>`, then for the specific pages where you want to introduce HTML into that yield space, you can do something like :
```
<% content_for :head do %>
  Whatever HTML ERB content you wanted to apply
<% end %>
```
