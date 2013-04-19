# Community Templates

A place for us to colloborate around templates and snippet for various OSes

# Repo format

So that the templates can eventually be updated automatically in Foreman, we are
adopting a specific format for this repo. For the most part, it is simply

    <operatingsystem>/<release>/<template_kind>.erb

Where `template_kind` is the name Foreman gives to the template (e.g. `gPXE` or
`finish`). The exception is snippets which are not tied to an OS:

    snippets/<snippet_name>.erb

Have a look around the repo for examples.

# Contributing

Please fork and send a pull request. Thanks!

# License

Copyrights are retained by their owners

This entire repository is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
