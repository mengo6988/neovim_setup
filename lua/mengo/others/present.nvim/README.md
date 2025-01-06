# `present.nvim`

This is a plugin to present Markdown files

# Usage

```lua
require("present").start_presentation()
```

Use `n` and `p` to navigate between slides
`q` to quit

`PresentStart` to start presentation of current markdown file

# Features: Neovim Lua Execution

Can execute lua code, when they are in the slide

```lua
print("hello world", 37)
```

# Features: other languages

Can execute code in Language blocks, when you have them in a slide.

You may need to configure this using `opts.executors`. Defaults has javascript and python.

# Example: javascript
Can execute javascript code, when they are in the slide

```javascript
console.log({myfield: true, other: false})
```

# Example: python
Can execute python code, when they are in the slide

```python
print("ayyayaayya python")
```
