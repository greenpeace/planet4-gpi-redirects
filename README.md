# planet4-gpi-redirects

Converts old URLS to new

## Making changes

The `redirects` and `rewrites` files are plain text whitespace-separated source / destination pairs. To add a new redirect, add a new line in this format:

```
/news/123/old-url https://www.greenpeace.org/international/123/new-url/
```

Once finished editing, run the build.sh script to automatically generate matching Apache and Nginx configuration files.
