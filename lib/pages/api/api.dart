var domain = "https://be.bitingku.com";

// post
var urlLogin = "${domain}/auth/login";
var urlRegister = "${domain}/auth/register";
var urlCreateDpp = "${domain}/dpp/createNew";

//put
var urlUpdateDpp = "${domain}/dpp/update";
var urlUpdatePassword = "${domain}/update/password";

// get
var urlGetProvinsi = "${domain}/provinsi/getall/json";
var urlGetKabupaten = "${domain}/kabupaten/get/";
var urlGetKecamatan = "${domain}/kecamatan/get/";
var urlGetDesa = "${domain}/desa/get/";
var urlGetKecamatanTps = "${domain}/kecamatan/getall";
var urlGetDesaTps = "${domain}/desa/getAllByKecamatanId/";
var urlGetDataTps = "${domain}/tps/getAllByDesaId/";
var urlGetDpt = "${domain}/dpt/count";
var urlGetDpp = "${domain}/dpp/count";

var searchDptByParams = "${domain}/dpp/search?";
var searchDptOnlyName = "${domain}/dpp/searchByName?";
