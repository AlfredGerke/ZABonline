/*
 *  Copyright (C) 2009-2011 VMware, Inc. All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *     http://www.apache.org/licenses/LICENSE-2.0
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

/*

Add custom widgets to projects made with WaveMaker Studio

Use the wm.loadLibs utility to load a set of custom widgets
you want to include in every WaveMaker project.

For project specific widgets, add the wm.loadLibs call to the project javascript file.

*/

// Example:
wm.loadLibs([ 
	"wm.packages.example.myButton"
]);

/* WARNING: This file is loaded at design time, and when running in debug mode, but is NOT loaded
 * when running your project without ?debug; do NOT put code in here required by your running projects!
 */