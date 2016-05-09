# GuiTesting

provides a lightweigt support for automated user interface testing with XCTest and Xcode

See  http://www.banyanshade-software.com/blog/gui-automatic-testing-with-xctest-and-xcode-12

This is very preliminary, and contributors are welcomed !

It's intended for OS X, but very probably usable on iOS with little modifications

** NOTE **

This was developped before XCode and XCTest support UI testing

However, it's not obsolete. Compared to XCTest UI testing :

1) execution is much much faster
for me it's a key point, because when you have e.g. more than 50 UI tests (which is far
from what you generally need to get a good coverage !), test execution is so long with XCTest
that I'm not running the tests enough often - early detection of regression is important

2) it provides a different test level
UI testing with XCTest is at app level, and your test program is a independant binary. The
good point is that it allows "black box" testing - validating the whole unmodified application.
On the other hand, GuiTesting is embedded with the application. It allows you to access directly 
the model data, or the view information. While this can be less clean, it sometime allows much
easier validation (and thus a better test coverage)

3) because of single binary approach, debugging is easier

I'm currently using both XCTest UI testing and GuiTesting in my development, using the approach
that is the most revelant for a given test

