/*
 *  Copyright (C) 2010-2012 VMware, Inc. All rights reserved.
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

dojo.declare("Login", wm.Page, {
    "preferredDevice": "desktop",
    "i18n": true,
    createSHA512OnRequireReady: function() {
        this.sha512 = new SHA512(0, "=");
    },
    start: function() {
        wm.require("zabonline.crypt.SHA512", true);
        dojo.ready(this, "createSHA512OnRequireReady");
        //
        this.connect(this.domNode, "keydown", this, "keydown");
        this.usernameInput.setDataValue(dojo.cookie("user") || "");
        this.usernameInput.focus();
        if (this.wmTitle) this.wmTitle.setCaption(app.name || app.declaredClass);
    },
    keydown: function(e) {
        if (e.keyCode == dojo.keys.ENTER) {
            this.loginButton.domNode.focus();
        }
    },
    loginButtonClick: function(inSender) {
        dojo.cookie("user", this.usernameInput.getDataValue(), {
            expires: 365
        });
        this.loginErrorMsg.setCaption("");
        wm.login([this.usernameInput.getDataValue(), this.sha512.hex_sha512(this.passwordInput.getDataValue())], null, dojo.hitch(this, "loginFailed"));
    },
    loginFailed: function(inResponse) {
        this.loginErrorMsg.setCaption(this.getDictionaryItem("CAPTION_LOGIN_FAILED"));
        this.usernameInput.focus();
    },
    _end: 0
});