//----------------------------------
// jQueryを使用出来るようにするための準備
//----------------------------------

if (typeof module === "object" && module.exports) {
    window.$ = window.jQuery = module.exports;
    module.exports = {};
}
