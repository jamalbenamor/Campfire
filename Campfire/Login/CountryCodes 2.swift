////
////  CountryCodes.swift
////  Campfire
////
////  Created by Jamal Benamor on 09/06/2022.
////
//
//import Foundation
//import UIKit
//
struct CountryData {
    var name: String
    var dial_code: String
    var code: String
    var preferred: Bool?
    var flag: String
    
}
//
struct CountryCodes {

    static var Countries:[CountryData] = [
    CountryData(
        name:"Afghanistan",
        dial_code:"+93",
        code:"AF",
        flag:"🇦🇫"
    ),
    CountryData(
       name:"Albania",
       dial_code:"+355",
       code:"AL",
       flag:"🇦🇱"
    ),
    CountryData(
       name:"Algeria",
       dial_code:"+213",
       code:"DZ",
       flag:"🇩🇿"
    ),
    CountryData(
       name:"American Samoa",
       dial_code:"+1684",
       code:"AS",
       flag:"🇦🇸"
    ),
    CountryData(
       name:"Andorra",
       dial_code:"+376",
       code:"AD",
       flag:"🇦🇩"
    ),
    CountryData(
       name:"Angola",
       dial_code:"+244",
       code:"AO",
       flag:"🇦🇴"
    ),
    CountryData(
       name:"Anguilla",
       dial_code:"+1264",
       code:"AI",
       flag:"🇦🇮"
    ),
    CountryData(
       name:"Antarctica",
       dial_code:"+672",
       code:"AQ",
       flag:"🇦🇶"
    ),
    CountryData(
       name:"Antigua and Barbuda",
       dial_code:"+1268",
       code:"AG",
       flag:"🇦🇬"
    ),
    CountryData(
       name:"Argentina",
       dial_code:"+54",
       code:"AR",
       flag:"🇦🇷"
    ),
    CountryData(
       name:"Armenia",
       dial_code:"+374",
       code:"AM",
       flag:"🇦🇲"
    ),
    CountryData(
       name:"Aruba",
       dial_code:"+297",
       code:"AW",
       flag:"🇦🇼"
    ),
    CountryData(
       name:"Australia",
       dial_code:"+61",
       code:"AU",
       preferred:true,
       flag:"🇦🇺"
    ),
    CountryData(
       name:"Austria",
       dial_code:"+43",
       code:"AT",
       flag:"🇦🇹"
    ),
    CountryData(
       name:"Azerbaijan",
       dial_code:"+994",
       code:"AZ",
       flag:"🇦🇿"
    ),
    CountryData(
       name:"Bahamas",
       dial_code:"+1242",
       code:"BS",
       flag:"🇧🇸"
    ),
    CountryData(
       name:"Bahrain",
       dial_code:"+973",
       code:"BH",
       flag:"🇧🇭"
    ),
    CountryData(
       name:"Bangladesh",
       dial_code:"+880",
       code:"BD",
       flag:"🇧🇩"
    ),
    CountryData(
       name:"Barbados",
       dial_code:"+1246",
       code:"BB",
       flag:"🇧🇧"
    ),
    CountryData(
       name:"Belarus",
       dial_code:"+375",
       code:"BY",
       flag:"🇧🇾"
    ),
    CountryData(
       name:"Belgium",
       dial_code:"+32",
       code:"BE",
       preferred: true,
       flag:"🇧🇪"
    ),
    CountryData(
       name:"Belize",
       dial_code:"+501",
       code:"BZ",
       flag:"🇧🇿"
    ),
    CountryData(
       name:"Benin",
       dial_code:"+229",
       code:"BJ",
       flag:"🇧🇯"
    ),
    CountryData(
       name:"Bermuda",
       dial_code:"+1441",
       code:"BM",
       flag:"🇧🇲"
    ),
    CountryData(
       name:"Bhutan",
       dial_code:"+975",
       code:"BT",
       flag:"🇧🇹"
    ),
    CountryData(
       name:"Bolivia",
       dial_code:"+591",
       code:"BO",
       flag:"🇧🇴"
    ),
    CountryData(
       name:"Bosnia and Herzegovina",
       dial_code:"+387",
       code:"BA",
       flag:"🇧🇦"
    ),
    CountryData(
       name:"Botswana",
       dial_code:"+267",
       code:"BW",
       flag:"🇧🇼"
    ),
    CountryData(
       name:"Brazil",
       dial_code:"+55",
       code:"BR",
       flag:"🇧🇷"
    ),
    CountryData(
       name:"British Indian Ocean Territory",
       dial_code:"+246",
       code:"IO",
       flag:"🇮🇴"
    ),
    CountryData(
       name:"Brunei Darussalam",
       dial_code:"+673",
       code:"BN",
       flag:"🇧🇳"
    ),
    CountryData(
       name:"Bulgaria",
       dial_code:"+359",
       code:"BG",
       flag:"🇧🇬"
    ),
    CountryData(
       name:"Burkina Faso",
       dial_code:"+226",
       code:"BF",
       flag:"🇧🇫"
    ),
    CountryData(
       name:"Burundi",
       dial_code:"+257",
       code:"BI",
       flag:"🇧🇮"
    ),
    CountryData(
       name:"Cambodia",
       dial_code:"+855",
       code:"KH",
       flag:"🇰🇭"
    ),
    CountryData(
       name:"Cameroon",
       dial_code:"+237",
       code:"CM",
       flag:"🇨🇲"
    ),
    CountryData(
       name:"Canada",
       dial_code:"+1",
       code:"CA",
       flag:"🇨🇦"
    ),
    CountryData(
       name:"Cape Verde",
       dial_code:"+238",
       code:"CV",
       flag:"🇨🇻"
    ),
    CountryData(
       name:"Cayman Islands",
       dial_code:"+345",
       code:"KY",
       flag:"🇰🇾"
    ),
    CountryData(
       name:"Central African Republic",
       dial_code:"+236",
       code:"CF",
       flag:"🇨🇫"
    ),
    CountryData(
       name:"Chad",
       dial_code:"+235",
       code:"TD",
       flag:"🇹🇩"
    ),
    CountryData(
       name:"Chile",
       dial_code:"+56",
       code:"CL",
       flag:"🇨🇱"
    ),
    CountryData(
       name:"China",
       dial_code:"+86",
       code:"CN",
       flag:"🇨🇳"
    ),
    CountryData(
       name:"Christmas Island",
       dial_code:"+61",
       code:"CX",
       flag:"🇨🇽"
    ),
    CountryData(
       name:"Cocos (Keeling) Islands",
       dial_code:"+61",
       code:"CC",
       flag:"🇨🇨"
    ),
    CountryData(
       name:"Colombia",
       dial_code:"+57",
       code:"CO",
       flag:"🇨🇴"
    ),
    CountryData(
       name:"Comoros",
       dial_code:"+269",
       code:"KM",
       flag:"🇰🇲"
    ),
    CountryData(
       name:"Congo",
       dial_code:"+242",
       code:"CG",
       flag:"🇨🇬"
    ),
    CountryData(
       name:"The Democratic Republic of the Congo",
       dial_code:"+243",
       code:"CD",
       flag:"🇨🇩"
    ),
    CountryData(
       name:"Cook Islands",
       dial_code:"+682",
       code:"CK",
       flag:"🇨🇰"
    ),
    CountryData(
       name:"Costa Rica",
       dial_code:"+506",
       code:"CR",
       flag:"🇨🇷"
    ),
    CountryData(
       name:"Cote d'Ivoire",
       dial_code:"+225",
       code:"CI",
       flag:"🇨🇮"
    ),
    CountryData(
       name:"Croatia",
       dial_code:"+385",
       code:"HR",
       flag:"🇭🇷"
    ),
    CountryData(
       name:"Cuba",
       dial_code:"+53",
       code:"CU",
       flag:"🇨🇺"
    ),
    CountryData(
       name:"Cyprus",
       dial_code:"+537",
       code:"CY",
       flag:"🇨🇾"
    ),
    CountryData(
       name:"Czech Republic",
       dial_code:"+420",
       code:"CZ",
       flag:"🇨🇿"
    ),
    CountryData(
       name:"Denmark",
       dial_code:"+45",
       code:"DK",
       flag:"🇩🇰"
    ),
    CountryData(
       name:"Djibouti",
       dial_code:"+253",
       code:"DJ",
       flag:"🇩🇯"
    ),
    CountryData(
       name:"Dominica",
       dial_code:"+1767",
       code:"DM",
       flag:"🇩🇲"
    ),
    CountryData(
       name:"Dominican Republic",
       dial_code:"+1849",
       code:"DO",
       flag:"🇩🇴"
    ),
    CountryData(
       name:"Ecuador",
       dial_code:"+593",
       code:"EC",
       flag:"🇪🇨"
    ),
    CountryData(
       name:"Egypt",
       dial_code:"+20",
       code:"EG",
       flag:"🇪🇬"
    ),
    CountryData(
       name:"El Salvador",
       dial_code:"+503",
       code:"SV",
       flag:"🇸🇻"
    ),
    CountryData(
       name:"Equatorial Guinea",
       dial_code:"+240",
       code:"GQ",
       flag:"🇬🇶"
    ),
    CountryData(
       name:"Eritrea",
       dial_code:"+291",
       code:"ER",
       flag:"🇪🇷"
    ),
    CountryData(
       name:"Estonia",
       dial_code:"+372",
       code:"EE",
       flag:"🇪🇪"
    ),
    CountryData(
       name:"Ethiopia",
       dial_code:"+251",
       code:"ET",
       flag:"🇪🇹"
    ),
    CountryData(
       name:"Falkland Islands (Malvinas)",
       dial_code:"+500",
       code:"FK",
       flag:"🇫🇰"
    ),
    CountryData(
       name:"Faroe Islands",
       dial_code:"+298",
       code:"FO",
       flag:"🇫🇴"
    ),
    CountryData(
       name:"Fiji",
       dial_code:"+679",
       code:"FJ",
       flag:"🇫🇯"
    ),
    CountryData(
       name:"Finland",
       dial_code:"+358",
       code:"FI",
       flag:"🇫🇮"
    ),
    CountryData(
       name:"France",
       dial_code:"+33",
       code:"FR",
       preferred: true,
       flag:"🇫🇷"
    ),
    CountryData(
       name:"French Guiana",
       dial_code:"+594",
       code:"GF",
       flag:"🇬🇫"
    ),
    CountryData(
       name:"French Polynesia",
       dial_code:"+689",
       code:"PF",
       flag:"🇵🇫"
    ),
    CountryData(
       name:"Gabon",
       dial_code:"+241",
       code:"GA",
       flag:"🇬🇦"
    ),
    CountryData(
       name:"Gambia",
       dial_code:"+220",
       code:"GM",
       flag:"🇬🇲"
    ),
    CountryData(
       name:"Georgia",
       dial_code:"+995",
       code:"GE",
       flag:"🇬🇪"
    ),
    CountryData(
       name:"Germany",
       dial_code:"+49",
       code:"DE",
       preferred: true,
       flag:"🇩🇪"
    ),
    CountryData(
       name:"Ghana",
       dial_code:"+233",
       code:"GH",
       flag:"🇬🇭"
    ),
    CountryData(
       name:"Gibraltar",
       dial_code:"+350",
       code:"GI",
       flag:"🇬🇮"
    ),
    CountryData(
       name:"Greece",
       dial_code:"+30",
       code:"GR",
       flag:"🇬🇷"
    ),
    CountryData(
       name:"Greenland",
       dial_code:"+299",
       code:"GL",
       flag:"🇬🇱"
    ),
    CountryData(
       name:"Grenada",
       dial_code:"+1473",
       code:"GD",
       flag:"🇬🇩"
    ),
    CountryData(
       name:"Guadeloupe",
       dial_code:"+590",
       code:"GP",
       flag:"🇬🇵"
    ),
    CountryData(
       name:"Guam",
       dial_code:"+1671",
       code:"GU",
       flag:"🇬🇺"
    ),
    CountryData(
       name:"Guatemala",
       dial_code:"+502",
       code:"GT",
       flag:"🇬🇹"
    ),
    CountryData(
       name:"Guernsey",
       dial_code:"+44",
       code:"GG",
       flag:"🇬🇬"
    ),
    CountryData(
       name:"Guinea",
       dial_code:"+224",
       code:"GN",
       flag:"🇬🇳"
    ),
    CountryData(
       name:"Guinea-Bissau",
       dial_code:"+245",
       code:"GW",
       flag:"🇬🇼"
    ),
    CountryData(
       name:"Guyana",
       dial_code:"+595",
       code:"GY",
       flag:"🇬🇾"
    ),
    CountryData(
       name:"Haiti",
       dial_code:"+509",
       code:"HT",
       flag:"🇭🇹"
    ),
    CountryData(
       name:"Holy See (Vatican City State)",
       dial_code:"+379",
       code:"VA",
       flag:"🇻🇦"
    ),
    CountryData(
       name:"Honduras",
       dial_code:"+504",
       code:"HN",
       flag:"🇭🇳"
    ),
    CountryData(
       name:"Hong Kong",
       dial_code:"+852",
       code:"HK",
       flag:"🇭🇰"
    ),
    CountryData(
       name:"Hungary",
       dial_code:"+36",
       code:"HU",
       flag:"🇭🇺"
    ),
    CountryData(
       name:"Iceland",
       dial_code:"+354",
       code:"IS",
       flag:"🇮🇸"
    ),
    CountryData(
       name:"India",
       dial_code:"+91",
       code:"IN",
       preferred:true,
       flag:"🇮🇳"
    ),
    CountryData(
       name:"Indonesia",
       dial_code:"+62",
       code:"ID",
       flag:"🇮🇩"
    ),
    CountryData(
       name:"Islamic Republic of Iran",
       dial_code:"+98",
       code:"IR",
       flag:"🇮🇷"
    ),
    CountryData(
       name:"Iraq",
       dial_code:"+964",
       code:"IQ",
       flag:"🇮🇶"
    ),
    CountryData(
       name:"Ireland",
       dial_code:"+353",
       code:"IE",
       flag:"🇮🇪"
    ),
    CountryData(
       name:"Isle of Man",
       dial_code:"+44",
       code:"IM",
       flag:"🇮🇲"
    ),
    CountryData(
       name:"Israel",
       dial_code:"+972",
       code:"IL",
       flag:"🇮🇱"
    ),
    CountryData(
       name:"Italy",
       dial_code:"+39",
       code:"IT",
       flag:"🇮🇹"
    ),
    CountryData(
       name:"Jamaica",
       dial_code:"+1876",
       code:"JM",
       flag:"🇯🇲"
    ),
    CountryData(
       name:"Japan",
       dial_code:"+81",
       code:"JP",
       flag:"🇯🇵"
    ),
    CountryData(
       name:"Jersey",
       dial_code:"+44",
       code:"JE",
       flag:"🇯🇪"
    ),
    CountryData(
       name:"Jordan",
       dial_code:"+962",
       code:"JO",
       flag:"🇯🇴"
    ),
    CountryData(
       name:"Kazakhstan",
       dial_code:"+77",
       code:"KZ",
       flag:"🇰🇿"
    ),
    CountryData(
       name:"Kenya",
       dial_code:"+254",
       code:"KE",
       flag:"🇰🇪"
    ),
    CountryData(
       name:"Kiribati",
       dial_code:"+686",
       code:"KI",
       flag:"🇰🇮"
    ),
    CountryData(
       name:"Democratic People's Republic of Korea",
       dial_code:"+850",
       code:"KP",
       flag:"🇰🇵"
    ),
    CountryData(
       name:"Republic of Korea",
       dial_code:"+82",
       code:"KR",
       flag:"🇰🇷"
    ),
    CountryData(
       name:"Kuwait",
       dial_code:"+965",
       code:"KW",
       flag:"🇰🇼"
    ),
    CountryData(
       name:"Kyrgyzstan",
       dial_code:"+996",
       code:"KG",
       flag:"🇰🇬"
    ),
    CountryData(
       name:"Lao People's Democratic Republic",
       dial_code:"+856",
       code:"LA",
       flag:"🇱🇦"
    ),
    CountryData(
       name:"Latvia",
       dial_code:"+371",
       code:"LV",
       flag:"🇱🇻"
    ),
    CountryData(
       name:"Lebanon",
       dial_code:"+961",
       code:"LB",
       flag:"🇱🇧"
    ),
    CountryData(
       name:"Lesotho",
       dial_code:"+266",
       code:"LS",
       flag:"🇱🇸"
    ),
    CountryData(
       name:"Liberia",
       dial_code:"+231",
       code:"LR",
       flag:"🇱🇷"
    ),
    CountryData(
       name:"Libyan Arab Jamahiriya",
       dial_code:"+218",
       code:"LY",
       flag:"🇱🇾"
    ),
    CountryData(
       name:"Liechtenstein",
       dial_code:"+423",
       code:"LI",
       flag:"🇱🇮"
    ),
    CountryData(
       name:"Lithuania",
       dial_code:"+370",
       code:"LT",
       flag:"🇱🇹"
    ),
    CountryData(
       name:"Luxembourg",
       dial_code:"+352",
       code:"LU",
       flag:"🇱🇺"
    ),
    CountryData(
       name:"Macao",
       dial_code:"+853",
       code:"MO",
       flag:"🇲🇴"
    ),
    CountryData(
       name:"The Former Yugoslav Republic of Macedonia",
       dial_code:"+389",
       code:"MK",
       flag:"🇲🇰"
    ),
    CountryData(
       name:"Madagascar",
       dial_code:"+261",
       code:"MG",
       flag:"🇲🇬"
    ),
    CountryData(
       name:"Malawi",
       dial_code:"+265",
       code:"MW",
       flag:"🇲🇼"
    ),
    CountryData(
       name:"Malaysia",
       dial_code:"+60",
       code:"MY",
       flag:"🇲🇾"
    ),
    CountryData(
       name:"Maldives",
       dial_code:"+960",
       code:"MV",
       flag:"🇲🇻"
    ),
    CountryData(
       name:"Mali",
       dial_code:"+223",
       code:"ML",
       flag:"🇲🇱"
    ),
    CountryData(
       name:"Malta",
       dial_code:"+356",
       code:"MT",
       flag:"🇲🇹"
    ),
    CountryData(
       name:"Marshall Islands",
       dial_code:"+692",
       code:"MH",
       flag:"🇲🇭"
    ),
    CountryData(
       name:"Martinique",
       dial_code:"+596",
       code:"MQ",
       flag:"🇲🇶"
    ),
    CountryData(
       name:"Mauritania",
       dial_code:"+222",
       code:"MR",
       flag:"🇲🇷"
    ),
    CountryData(
       name:"Mauritius",
       dial_code:"+230",
       code:"MU",
       flag:"🇲🇺"
    ),
    CountryData(
       name:"Mayotte",
       dial_code:"+262",
       code:"YT",
       flag:"🇾🇹"
    ),
    CountryData(
       name:"Mexico",
       dial_code:"+52",
       code:"MX",
       flag:"🇲🇽"
    ),
    CountryData(
       name:"Federated States of Micronesia",
       dial_code:"+691",
       code:"FM",
       flag:"🇫🇲"
    ),
    CountryData(
       name:"Republic of Moldova",
       dial_code:"+373",
       code:"MD",
       flag:"🇲🇩"
    ),
    CountryData(
       name:"Monaco",
       dial_code:"+377",
       code:"MC",
       flag:"🇲🇨"
    ),
    CountryData(
       name:"Mongolia",
       dial_code:"+976",
       code:"MN",
       flag:"🇲🇳"
    ),
    CountryData(
       name:"Montenegro",
       dial_code:"+382",
       code:"ME",
       flag:"🇲🇪"
    ),
    CountryData(
       name:"Montserrat",
       dial_code:"+1664",
       code:"MS",
       flag:"🇲🇸"
    ),
    CountryData(
       name:"Morocco",
       dial_code:"+212",
       code:"MA",
       flag:"🇲🇦"
    ),
    CountryData(
       name:"Mozambique",
       dial_code:"+258",
       code:"MZ",
       flag:"🇲🇿"
    ),
    CountryData(
       name:"Myanmar",
       dial_code:"+95",
       code:"MM",
       flag:"🇲🇲"
    ),
    CountryData(
       name:"Namibia",
       dial_code:"+264",
       code:"NA",
       flag:"🇳🇦"
    ),
    CountryData(
       name:"Nauru",
       dial_code:"+674",
       code:"NR",
       flag:"🇳🇷"
    ),
    CountryData(
       name:"Nepal",
       dial_code:"+977",
       code:"NP",
       flag:"🇳🇵"
    ),
    CountryData(
       name:"Netherlands",
       dial_code:"+31",
       code:"NL",
       flag:"🇳🇱"
    ),
    CountryData(
       name:"Netherlands Antilles",
       dial_code:"+599",
       code:"AN",
       flag:"🇦🇳"
    ),
    CountryData(
       name:"New Caledonia",
       dial_code:"+687",
       code:"NC",
       flag:"🇳🇨"
    ),
    CountryData(
       name:"New Zealand",
       dial_code:"+64",
       code:"NZ",
       flag:"🇳🇿"
    ),
    CountryData(
       name:"Nicaragua",
       dial_code:"+505",
       code:"NI",
       flag:"🇳🇮"
    ),
    CountryData(
       name:"Niger",
       dial_code:"+227",
       code:"NE",
       flag:"🇳🇪"
    ),
    CountryData(
       name:"Nigeria",
       dial_code:"+234",
       code:"NG",
       flag:"🇳🇬"
    ),
    CountryData(
       name:"Niue",
       dial_code:"+683",
       code:"NU",
       flag:"🇳🇺"
    ),
    CountryData(
       name:"Norfolk Island",
       dial_code:"+672",
       code:"NF",
       flag:"🇳🇫"
    ),
    CountryData(
       name:"Northern Mariana Islands",
       dial_code:"+1670",
       code:"MP",
       flag:"🇲🇵"
    ),
    CountryData(
       name:"Norway",
       dial_code:"+47",
       code:"NO",
       flag:"🇳🇴"
    ),
    CountryData(
       name:"Oman",
       dial_code:"+968",
       code:"OM",
       flag:"🇴🇲"
    ),
    CountryData(
       name:"Pakistan",
       dial_code:"+92",
       code:"PK",
       flag:"🇵🇰"
    ),
    CountryData(
       name:"Palau",
       dial_code:"+680",
       code:"PW",
       flag:"🇵🇼"
    ),
    CountryData(
       name:"Palestinian Territory, Occupied",
       dial_code:"+970",
       code:"PS",
       flag:"🇵🇸"
    ),
    CountryData(
       name:"Panama",
       dial_code:"+507",
       code:"PA",
       flag:"🇵🇦"
    ),
    CountryData(
       name:"Papua New Guinea",
       dial_code:"+675",
       code:"PG",
       flag:"🇵🇬"
    ),
    CountryData(
       name:"Paraguay",
       dial_code:"+595",
       code:"PY",
       flag:"🇵🇾"
    ),
    CountryData(
       name:"Peru",
       dial_code:"+51",
       code:"PE",
       flag:"🇵🇪"
    ),
    CountryData(
       name:"Philippines",
       dial_code:"+63",
       code:"PH",
       flag:"🇵🇭"
    ),
    CountryData(
       name:"Pitcairn",
       dial_code:"+872",
       code:"PN",
       flag:"🇵🇳"
    ),
    CountryData(
       name:"Poland",
       dial_code:"+48",
       code:"PL",
       flag:"🇵🇱"
    ),
    CountryData(
       name:"Portugal",
       dial_code:"+351",
       code:"PT",
       flag:"🇵🇹"
    ),
    CountryData(
       name:"Puerto Rico",
       dial_code:"+1939",
       code:"PR",
       flag:"🇵🇷"
    ),
    CountryData(
       name:"Qatar",
       dial_code:"+974",
       code:"QA",
       flag:"🇶🇦"
    ),
    CountryData(
       name:"Romania",
       dial_code:"+40",
       code:"RO",
       flag:"🇷🇴"
    ),
    CountryData(
       name:"Russia",
       dial_code:"+7",
       code:"RU",
       flag:"🇷🇺"
    ),
    CountryData(
       name:"Rwanda",
       dial_code:"+250",
       code:"RW",
       flag:"🇷🇼"
    ),
    CountryData(
       name:"Réunion",
       dial_code:"+262",
       code:"RE",
       flag:"🇷🇪"
    ),
    CountryData(
       name:"Saint Barthélemy",
       dial_code:"+590",
       code:"BL",
       flag:"🇧🇱"
    ),
    CountryData(
       name:"Saint Helena, Ascension and Tristan Da Cunha",
       dial_code:"+290",
       code:"SH",
       flag:"🇸🇭"
    ),
    CountryData(
       name:"Saint Kitts and Nevis",
       dial_code:"+1869",
       code:"KN",
       flag:"🇰🇳"
    ),
    CountryData(
       name:"Saint Lucia",
       dial_code:"+1758",
       code:"LC",
       flag:"🇱🇨"
    ),
    CountryData(
       name:"Saint Martin",
       dial_code:"+590",
       code:"MF",
       flag:"🇲🇫"
    ),
    CountryData(
       name:"Saint Pierre and Miquelon",
       dial_code:"+508",
       code:"PM",
       flag:"🇵🇲"
    ),
    CountryData(
       name:"Saint Vincent and the Grenadines",
       dial_code:"+1784",
       code:"VC",
       flag:"🇻🇨"
    ),
    CountryData(
       name:"Samoa",
       dial_code:"+685",
       code:"WS",
       flag:"🇼🇸"
    ),
    CountryData(
       name:"San Marino",
       dial_code:"+378",
       code:"SM",
       flag:"🇸🇲"
    ),
    CountryData(
       name:"Sao Tome and Principe",
       dial_code:"+239",
       code:"ST",
       flag:"🇸🇹"
    ),
    CountryData(
       name:"Saudi Arabia",
       dial_code:"+966",
       code:"SA",
       flag:"🇸🇦"
    ),
    CountryData(
       name:"Senegal",
       dial_code:"+221",
       code:"SN",
       flag:"🇸🇳"
    ),
    CountryData(
       name:"Serbia",
       dial_code:"+381",
       code:"RS",
       flag:"🇷🇸"
    ),
    CountryData(
       name:"Seychelles",
       dial_code:"+248",
       code:"SC",
       flag:"🇸🇨"
    ),
    CountryData(
       name:"Sierra Leone",
       dial_code:"+232",
       code:"SL",
       flag:"🇸🇱"
    ),
    CountryData(
       name:"Singapore",
       dial_code:"+65",
       code:"SG",
       flag:"🇸🇬"
    ),
    CountryData(
       name:"Slovakia",
       dial_code:"+421",
       code:"SK",
       flag:"🇸🇰"
    ),
    CountryData(
       name:"Slovenia",
       dial_code:"+386",
       code:"SI",
       flag:"🇸🇮"
    ),
    CountryData(
       name:"Solomon Islands",
       dial_code:"+677",
       code:"SB",
       flag:"🇸🇧"
    ),
    CountryData(
       name:"Somalia",
       dial_code:"+252",
       code:"SO",
       flag:"🇸🇴"
    ),
    CountryData(
       name:"South Africa",
       dial_code:"+27",
       code:"ZA",
       flag:"🇿🇦"
    ),
    CountryData(
       name:"South Georgia and the South Sandwich Islands",
       dial_code:"+500",
       code:"GS",
       flag:"🇬🇸"
    ),
    CountryData(
       name:"Spain",
       dial_code:"+34",
       code:"ES",
       preferred: true,
       flag:"🇪🇸"
    ),
    CountryData(
       name:"Sri Lanka",
       dial_code:"+94",
       code:"LK",
       flag:"🇱🇰"
    ),
    CountryData(
       name:"Sudan",
       dial_code:"+249",
       code:"SD",
       flag:"🇸🇩"
    ),
    CountryData(
       name:"Suriname",
       dial_code:"+597",
       code:"SR",
       flag:"🇸🇷"
    ),
    CountryData(
       name:"Svalbard and Jan Mayen",
       dial_code:"+47",
       code:"SJ",
       flag:"🇸🇯"
    ),
    CountryData(
       name:"Swaziland",
       dial_code:"+268",
       code:"SZ",
       flag:"🇸🇿"
    ),
    CountryData(
       name:"Sweden",
       dial_code:"+46",
       code:"SE",
       flag:"🇸🇪"
    ),
    CountryData(
       name:"Switzerland",
       dial_code:"+41",
       code:"CH",
       flag:"🇨🇭"
    ),
    CountryData(
       name:"Syrian Arab Republic",
       dial_code:"+963",
       code:"SY",
       flag:"🇸🇾"
    ),
    CountryData(
       name:"Taiwan, Province of China",
       dial_code:"+886",
       code:"TW",
       flag:"🇹🇼"
    ),
    CountryData(
       name:"Tajikistan",
       dial_code:"+992",
       code:"TJ",
       flag:"🇹🇯"
    ),
    CountryData(
       name:"Tanzania, United Republic of",
       dial_code:"+255",
       code:"TZ",
       flag:"🇹🇿"
    ),
    CountryData(
       name:"Thailand",
       dial_code:"+66",
       code:"TH",
       flag:"🇹🇭"
    ),
    CountryData(
       name:"Timor-Leste",
       dial_code:"+670",
       code:"TL",
       flag:"🇹🇱"
    ),
    CountryData(
       name:"Togo",
       dial_code:"+228",
       code:"TG",
       flag:"🇹🇬"
    ),
    CountryData(
       name:"Tokelau",
       dial_code:"+690",
       code:"TK",
       flag:"🇹🇰"
    ),
    CountryData(
       name:"Tonga",
       dial_code:"+676",
       code:"TO",
       flag:"🇹🇴"
    ),
    CountryData(
       name:"Trinidad and Tobago",
       dial_code:"+1868",
       code:"TT",
       flag:"🇹🇹"
    ),
    CountryData(
       name:"Tunisia",
       dial_code:"+216",
       code:"TN",
       flag:"🇹🇳"
    ),
    CountryData(
       name:"Turkey",
       dial_code:"+90",
       code:"TR",
       flag:"🇹🇷"
    ),
    CountryData(
       name:"Turkmenistan",
       dial_code:"+993",
       code:"TM",
       flag:"🇹🇲"
    ),
    CountryData(
       name:"Turks and Caicos Islands",
       dial_code:"+1649",
       code:"TC",
       flag:"🇹🇨"
    ),
    CountryData(
       name:"Tuvalu",
       dial_code:"+688",
       code:"TV",
       flag:"🇹🇻"
    ),
    CountryData(
       name:"Uganda",
       dial_code:"+256",
       code:"UG",
       flag:"🇺🇬"
    ),
    CountryData(
       name:"Ukraine",
       dial_code:"+380",
       code:"UA",
       flag:"🇺🇦"
    ),
    CountryData(
       name:"United Arab Emirates",
       dial_code:"+971",
       code:"AE",
       preferred:true,
       flag:"🇦🇪"
    ),
    CountryData(
       name:"United States",
       dial_code:"+1",
       code:"US",
       preferred:true,
       flag:"🇺🇸"
    ),
    CountryData(
       name:"United Kingdom",
       dial_code:"+44",
       code:"GB",
       preferred:true,
       flag:"🇬🇧"
    ),
    CountryData(
       name:"Uruguay",
       dial_code:"+598",
       code:"UY",
       flag:"🇺🇾"
    ),
    CountryData(
       name:"Uzbekistan",
       dial_code:"+998",
       code:"UZ",
       flag:"🇺🇿"
    ),
    CountryData(
       name:"Vanuatu",
       dial_code:"+678",
       code:"VU",
       flag:"🇻🇺"
    ),
    CountryData(
       name:"Venezuela, Bolivarian Republic of",
       dial_code:"+58",
       code:"VE",
       flag:"🇻🇪"
    ),
    CountryData(
       name:"Viet Nam",
       dial_code:"+84",
       code:"VN",
       flag:"🇻🇳"
    ),
    CountryData(
       name:"Virgin Islands, British",
       dial_code:"+1284",
       code:"VG",
       flag:"🇻🇬"
    ),
    CountryData(
       name:"Virgin Islands, U.S.",
       dial_code:"+1340",
       code:"VI",
       flag:"🇻🇮"
    ),
    CountryData(
       name:"Wallis and Futuna",
       dial_code:"+681",
       code:"WF",
       flag:"🇼🇫"
    ),
    CountryData(
       name:"Yemen",
       dial_code:"+967",
       code:"YE",
       flag:"🇾🇪"
    ),
    CountryData(
       name:"Zambia",
       dial_code:"+260",
       code:"ZM",
       flag:"🇿🇲"
    ),
    CountryData(
       name:"Zimbabwe",
       dial_code:"+263",
       code:"ZW",
       flag:"🇿🇼"
    ),
    CountryData(
       name:"Åland Islands",
       dial_code:"+358",
       code:"AX",
       flag:"🇦🇽"
    )
]
    
    static var CodeDict = [
        "BD": "+880", "BE": "+32", "BF": "+226", "BG": "+359", "BA": "+387", "BB": "+1246", "WF": "+681", "BL": "+590", "BM": "+1441", "BN": "+673", "BO": "+591", "BH": "+973", "BI": "+257", "BJ": "+229", "BT": "+975", "JM": "+1876", "BV": "", "BW": "+267", "WS": "+685", "BQ": "+599", "BR": "+55", "BS": "+1242", "JE": "+441534", "BY": "+375", "BZ": "+501", "RU": "+7", "RW": "+250", "RS": "+381", "TL": "+670", "RE": "+262", "TM": "+993", "TJ": "+992", "RO": "+40", "TK": "+690", "GW": "+245", "GU": "+1671", "GT": "+502", "GS": "", "GR": "+30", "GQ": "+240", "GP": "+590", "JP": "+81", "GY": "+592", "GG": "+441481", "GF": "+594", "GE": "+995", "GD": "+1473", "GB": "+44", "GA": "+241", "SV": "+503", "GN": "+224", "GM": "+220", "GL": "+299", "GI": "+350", "GH": "+233", "OM": "+968", "TN": "+216", "JO": "+962", "HR": "+385", "HT": "+509", "HU": "+36", "HK": "+852", "HN": "+504", "HM": " ", "VE": "+58", "PR": "+1787", "PS": "+970", "PW": "+680", "PT": "+351", "SJ": "+47", "PY": "+595", "IQ": "+964", "PA": "+507", "PF": "+689", "PG": "+675", "PE": "+51", "PK": "+92", "PH": "+63", "PN": "+870", "PL": "+48", "PM": "+508", "ZM": "+260", "EH": "+212", "EE": "+372", "EG": "+20", "ZA": "+27", "EC": "+593", "IT": "+39", "VN": "+84", "SB": "+677", "ET": "+251", "SO": "+252", "ZW": "+263", "SA": "+966", "ES": "+34", "ER": "+291", "ME": "+382", "MD": "+373", "MG": "+261", "MF": "+590", "MA": "+212", "MC": "+377", "UZ": "+998", "MM": "+95", "ML": "+223", "MO": "+853", "MN": "+976", "MH": "+692", "MK": "+389", "MU": "+230", "MT": "+356", "MW": "+265", "MV": "+960", "MQ": "+596", "MP": "+1670", "MS": "+1664", "MR": "+222", "IM": "+441624", "UG": "+256", "TZ": "+255", "MY": "+60", "MX": "+52", "IL": "+972", "FR": "+33", "IO": "+246", "SH": "+290", "FI": "+358", "FJ": "+679", "FK": "+500", "FM": "+691", "FO": "+298", "NI": "+505", "NL": "+31", "NO": "+47", "NA": "+264", "VU": "+678", "NC": "+687", "NE": "+227", "NF": "+672", "NG": "+234", "NZ": "+64", "NP": "+977", "NR": "+674", "NU": "+683", "CK": "+682", "XK": "", "CI": "+225", "CH": "+41", "CO": "+57", "CN": "+86", "CM": "+237", "CL": "+56", "CC": "+61", "CA": "+1", "CG": "+242", "CF": "+236", "CD": "+243", "CZ": "+420", "CY": "+357", "CX": "+61", "CR": "+506", "CW": "+599", "CV": "+238", "CU": "+53", "SZ": "+268", "SY": "+963", "SX": "+599", "KG": "+996", "KE": "+254", "SS": "+211", "SR": "+597", "KI": "+686", "KH": "+855", "KN": "+1869", "KM": "+269", "ST": "+239", "SK": "+421", "KR": "+82", "SI": "+386", "KP": "+850", "KW": "+965", "SN": "+221", "SM": "+378", "SL": "+232", "SC": "+248", "KZ": "+7", "KY": "+1345", "SG": "+65", "SE": "+46", "SD": "+249", "DO": "+1809", "DM": "+1767", "DJ": "+253", "DK": "+45", "VG": "+1284", "DE": "+49", "YE": "+967", "DZ": "+213", "US": "+1", "UY": "+598", "YT": "+262", "UM": "+1", "LB": "+961", "LC": "+1758", "LA": "+856", "TV": "+688", "TW": "+886", "TT": "+1868", "TR": "+90", "LK": "+94", "LI": "+423", "LV": "+371", "TO": "+676", "LT": "+370", "LU": "+352", "LR": "+231", "LS": "+266", "TH": "+66", "TF": "", "TG": "+228", "TD": "+235", "TC": "+1649", "LY": "+218", "VA": "+379", "VC": "+1784", "AE": "+971", "AD": "+376", "AG": "+1268", "AF": "+93", "AI": "+1264", "VI": "+1340", "IS": "+354", "IR": "+98", "AM": "+374", "AL": "+355", "AO": "+244", "AQ": "", "AS": "+1684", "AR": "+54", "AU": "+61", "AT": "+43", "AW": "+297", "IN": "+91", "AX": "+35818", "AZ": "+994", "IE": "+353", "ID": "+62", "UA": "+380", "QA": "+974", "MZ": "+258"
    ]

    
    
 
}
