# myemacs cookbook

The myemacs cookbook manages the configuration (i.e. the settings) but
not the installatino of Emacs according to my preferences.

Use this cookbook to provide a common Emacs experience across your
favorite workstations.

## Installation

There are two basic ways to use this cookbook:
1. Manually execute the cookbook locally on the system in which you
want to configure emacs
2. Upload the cookbook to a Chef Server and configure it in the
runlist of the desired nodes

### Prerequisites

You'll need to do the following for either the Chef Server or local
workstation use cases:

* Install [BerkShelf](http://berkshelf.com/) -- the easiest way to get
BerkShelf is to simply [install ChefDK](https://downloads.chef.io/chef-dk/).
* Since this cookbook doesn't install Emacs, you should do this
  yourself either before or after configuring systems via this cookbook.

### Local execution on your workstation
Let's say you're comfortable just running a few commands on a
particular workstation where you need your Emacs configured. Just
clone this repository and run the setup, as follows:

```sh
git clone git@github.com:/adamedx/myemacs
cd myemacs
./files/localsetup.sh
```

Alternatively, you can simply use Chef Client local mode to execute
this cookbook's default recipe -- you'll need to be sure you've made
all the cookbook dependencies available locally (e.g. via `berks
install`) before you do this.

### Upload to your Chef Server

You can upload this cookbook to your Chef Server with the following
instructions, assuming you have configured Chef and Berkshelf tools
for appropriate configuration of the server:

```sh
cd $YOUR_COOKBOOK_PATH
git clone git@github.com:/adamedx/myemacs
cd myemacs
berks install
berks upload myemacs
```

### Features

This cookbook provides the following capabilities

* Allows you to keep a common Emacs configuration wherever you have
  Internet access
* Configures a `.emacs` file with customizations from https://github.com/adamedx/myemacs.
* Enables `powershell-mode` for PowerShell (`.ps1`) files
* Enables `markdown-mode` for Markdown (`.md`) files
* All features are supported on both Windows and Unix operating
  systems

# License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

