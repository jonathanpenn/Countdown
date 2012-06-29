# Purpose

This is an app I wrote to explore RubyMotion. It counts down the number of days
to a date in the future and visualizes it with a scrollable week view. You can
have as many countdowns as you want. When viewing a countdown, swipe to go back
to the list. Double tap to edit.

I wanted to avoid extra dependencies so I'm not using any of the DSLs for
building table views or other cocoa touch help. The app makes use of:

- Gesture recognizers
- CoreAnimation effects
- Scroll view parallaxing
- Experiements with my own custome DSL, Patchwork.

Patchwork is my initial attempt to provide objects you can mix in when you
want to use extra features rather than patching core classes. In effect, I want
to monkey patch in isolation on the fly rather than patching the whole system
for the entire app run.

# Future

- Use CoreData
- iCloud
- Loading custom table view cell from a nib

# License

Copyright (c) 2012 Jonathan Penn

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
