# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  browser            :string
#  city               :string
#  country            :string
#  data_source        :string           default("web")
#  device_type        :string
#  engagement_time    :integer
#  event_name         :string           default("page_view")
#  event_props        :jsonb
#  hostname           :string
#  ip                 :string
#  latitude           :float
#  location_url       :string
#  longitude          :float
#  os                 :string
#  path               :string
#  protocol_version   :string           default("2")
#  raw_event          :jsonb
#  referrer           :string
#  referrer_source    :string
#  region             :string
#  request_number     :integer
#  request_params     :jsonb
#  screen_resolution  :string
#  session_count      :integer
#  session_engagement :boolean          default(FALSE)
#  started_at         :datetime         not null
#  title              :string
#  traffic_campaign   :string
#  traffic_medium     :string
#  traffic_source     :string
#  user_agent         :string
#  user_language      :string
#  user_props         :jsonb
#  client_id          :string           not null
#  session_id         :string           not null
#  site_id            :string           not null
#  tracking_id        :string           not null
#  user_id            :string
#
# Indexes
#
#  events_started_at_idx                                  (started_at)
#  index_events_on_site_id_and_session_id_and_started_at  (site_id,session_id,started_at DESC)
#
module Hyper
  class Event < ApplicationHyperRecord
    COUNTRY_2_TO_FULL = {
      "AF" => "Afghanistan",
      "AX" => "Aland Islands",
      "AL" => "Albania",
      "DZ" => "Algeria",
      "AS" => "American Samoa",
      "AD" => "Andorra",
      "AO" => "Angola",
      "AI" => "Anguilla",
      "AQ" => "Antarctica",
      "AG" => "Antigua And Barbuda",
      "AR" => "Argentina",
      "AM" => "Armenia",
      "AW" => "Aruba",
      "AU" => "Australia",
      "AT" => "Austria",
      "AZ" => "Azerbaijan",
      "BS" => "Bahamas",
      "BH" => "Bahrain",
      "BD" => "Bangladesh",
      "BB" => "Barbados",
      "BY" => "Belarus",
      "BE" => "Belgium",
      "BZ" => "Belize",
      "BJ" => "Benin",
      "BM" => "Bermuda",
      "BT" => "Bhutan",
      "BO" => "Bolivia",
      "BA" => "Bosnia And Herzegovina",
      "BW" => "Botswana",
      "BV" => "Bouvet Island",
      "BR" => "Brazil",
      "IO" => "British Indian Ocean Territory",
      "BN" => "Brunei Darussalam",
      "BG" => "Bulgaria",
      "BF" => "Burkina Faso",
      "BI" => "Burundi",
      "KH" => "Cambodia",
      "CM" => "Cameroon",
      "CA" => "Canada",
      "CV" => "Cape Verde",
      "KY" => "Cayman Islands",
      "CF" => "Central African Republic",
      "TD" => "Chad",
      "CL" => "Chile",
      "CN" => "China",
      "CX" => "Christmas Island",
      "CC" => "Cocos (Keeling) Islands",
      "CO" => "Colombia",
      "KM" => "Comoros",
      "CG" => "Congo",
      "CD" => "Congo, Democratic Republic",
      "CK" => "Cook Islands",
      "CR" => "Costa Rica",
      "CI" => "Cote D\"Ivoire",
      "HR" => "Croatia",
      "CU" => "Cuba",
      "CY" => "Cyprus",
      "CZ" => "Czech Republic",
      "DK" => "Denmark",
      "DJ" => "Djibouti",
      "DM" => "Dominica",
      "DO" => "Dominican Republic",
      "EC" => "Ecuador",
      "EG" => "Egypt",
      "SV" => "El Salvador",
      "GQ" => "Equatorial Guinea",
      "ER" => "Eritrea",
      "EE" => "Estonia",
      "ET" => "Ethiopia",
      "FK" => "Falkland Islands (Malvinas)",
      "FO" => "Faroe Islands",
      "FJ" => "Fiji",
      "FI" => "Finland",
      "FR" => "France",
      "GF" => "French Guiana",
      "PF" => "French Polynesia",
      "TF" => "French Southern Territories",
      "GA" => "Gabon",
      "GM" => "Gambia",
      "GE" => "Georgia",
      "DE" => "Germany",
      "GH" => "Ghana",
      "GI" => "Gibraltar",
      "GR" => "Greece",
      "GL" => "Greenland",
      "GD" => "Grenada",
      "GP" => "Guadeloupe",
      "GU" => "Guam",
      "GT" => "Guatemala",
      "GG" => "Guernsey",
      "GN" => "Guinea",
      "GW" => "Guinea-Bissau",
      "GY" => "Guyana",
      "HT" => "Haiti",
      "HM" => "Heard Island & Mcdonald Islands",
      "VA" => "Holy See (Vatican City State)",
      "HN" => "Honduras",
      "HK" => "Hong Kong",
      "HU" => "Hungary",
      "IS" => "Iceland",
      "IN" => "India",
      "ID" => "Indonesia",
      "IR" => "Iran, Islamic Republic Of",
      "IQ" => "Iraq",
      "IE" => "Ireland",
      "IM" => "Isle Of Man",
      "IL" => "Israel",
      "IT" => "Italy",
      "JM" => "Jamaica",
      "JP" => "Japan",
      "JE" => "Jersey",
      "JO" => "Jordan",
      "KZ" => "Kazakhstan",
      "KE" => "Kenya",
      "KI" => "Kiribati",
      "KR" => "Korea",
      "KW" => "Kuwait",
      "KG" => "Kyrgyzstan",
      "LA" => "Lao People\"s Democratic Republic",
      "LV" => "Latvia",
      "LB" => "Lebanon",
      "LS" => "Lesotho",
      "LR" => "Liberia",
      "LY" => "Libyan Arab Jamahiriya",
      "LI" => "Liechtenstein",
      "LT" => "Lithuania",
      "LU" => "Luxembourg",
      "MO" => "Macao",
      "MK" => "Macedonia",
      "MG" => "Madagascar",
      "MW" => "Malawi",
      "MY" => "Malaysia",
      "MV" => "Maldives",
      "ML" => "Mali",
      "MT" => "Malta",
      "MH" => "Marshall Islands",
      "MQ" => "Martinique",
      "MR" => "Mauritania",
      "MU" => "Mauritius",
      "YT" => "Mayotte",
      "MX" => "Mexico",
      "FM" => "Micronesia, Federated States Of",
      "MD" => "Moldova",
      "MC" => "Monaco",
      "MN" => "Mongolia",
      "ME" => "Montenegro",
      "MS" => "Montserrat",
      "MA" => "Morocco",
      "MZ" => "Mozambique",
      "MM" => "Myanmar",
      "NA" => "Namibia",
      "NR" => "Nauru",
      "NP" => "Nepal",
      "NL" => "Netherlands",
      "NC" => "New Caledonia",
      "NZ" => "New Zealand",
      "NI" => "Nicaragua",
      "NE" => "Niger",
      "NG" => "Nigeria",
      "NU" => "Niue",
      "NF" => "Norfolk Island",
      "MP" => "Northern Mariana Islands",
      "NO" => "Norway",
      "OM" => "Oman",
      "PK" => "Pakistan",
      "PW" => "Palau",
      "PS" => "Palestinian Territory, Occupied",
      "PA" => "Panama",
      "PG" => "Papua New Guinea",
      "PY" => "Paraguay",
      "PE" => "Peru",
      "PH" => "Philippines",
      "PN" => "Pitcairn",
      "PL" => "Poland",
      "PT" => "Portugal",
      "PR" => "Puerto Rico",
      "QA" => "Qatar",
      "RE" => "Reunion",
      "RO" => "Romania",
      "RU" => "Russian Federation",
      "RW" => "Rwanda",
      "BL" => "Saint Barthelemy",
      "SH" => "Saint Helena",
      "KN" => "Saint Kitts And Nevis",
      "LC" => "Saint Lucia",
      "MF" => "Saint Martin",
      "PM" => "Saint Pierre And Miquelon",
      "VC" => "Saint Vincent And Grenadines",
      "WS" => "Samoa",
      "SM" => "San Marino",
      "ST" => "Sao Tome And Principe",
      "SA" => "Saudi Arabia",
      "SN" => "Senegal",
      "RS" => "Serbia",
      "SC" => "Seychelles",
      "SL" => "Sierra Leone",
      "SG" => "Singapore",
      "SK" => "Slovakia",
      "SI" => "Slovenia",
      "SB" => "Solomon Islands",
      "SO" => "Somalia",
      "ZA" => "South Africa",
      "GS" => "South Georgia And Sandwich Isl.",
      "ES" => "Spain",
      "LK" => "Sri Lanka",
      "SD" => "Sudan",
      "SR" => "Suriname",
      "SJ" => "Svalbard And Jan Mayen",
      "SZ" => "Swaziland",
      "SE" => "Sweden",
      "CH" => "Switzerland",
      "SY" => "Syrian Arab Republic",
      "TW" => "Taiwan",
      "TJ" => "Tajikistan",
      "TZ" => "Tanzania",
      "TH" => "Thailand",
      "TL" => "Timor-Leste",
      "TG" => "Togo",
      "TK" => "Tokelau",
      "TO" => "Tonga",
      "TT" => "Trinidad And Tobago",
      "TN" => "Tunisia",
      "TR" => "Turkey",
      "TM" => "Turkmenistan",
      "TC" => "Turks And Caicos Islands",
      "TV" => "Tuvalu",
      "UG" => "Uganda",
      "UA" => "Ukraine",
      "AE" => "United Arab Emirates",
      "GB" => "United Kingdom",
      "US" => "United States",
      "UM" => "United States Outlying Islands",
      "UY" => "Uruguay",
      "UZ" => "Uzbekistan",
      "VU" => "Vanuatu",
      "VE" => "Venezuela",
      "VN" => "Viet Nam",
      "VG" => "Virgin Islands, British",
      "VI" => "Virgin Islands, U.S.",
      "WF" => "Wallis And Futuna",
      "EH" => "Western Sahara",
      "YE" => "Yemen",
      "ZM" => "Zambia",
      "ZW" => "Zimbabwe"
    }

    CONTRY_FULL_TO_2 = COUNTRY_2_TO_FULL.invert

    COUNTRY_2_TO_3 = {
      "SL" => "SLE",
      "VA" => "VAT",
      "SM" => "SMR",
      "TV" => "TUV",
      "KZ" => "KAZ",
      "PE" => "PER",
      "CD" => "COD",
      "SN" => "SEN",
      "BA" => "BIH",
      "VC" => "VCT",
      "TW" => "TWN",
      "NP" => "NPL",
      "UZ" => "UZB",
      "MY" => "MYS",
      "GM" => "GMB",
      "GA" => "GAB",
      "PW" => "PLW",
      "TH" => "THA",
      "NR" => "NRU",
      "KW" => "KWT",
      "MU" => "MUS",
      "GI" => "GIB",
      "BJ" => "BEN",
      "AR" => "ARG",
      "SA" => "SAU",
      "GW" => "GNB",
      "AT" => "AUT",
      "AW" => "ABW",
      "MZ" => "MOZ",
      "IT" => "ITA",
      "BI" => "BDI",
      "GR" => "GRC",
      "FO" => "FRO",
      "SD" => "SDN",
      "PS" => "PSE",
      "SB" => "SLB",
      "KR" => "KOR",
      "TR" => "TUR",
      "ST" => "STP",
      "JP" => "JPN",
      "TG" => "TGO",
      "GQ" => "GNQ",
      "PH" => "PHL",
      "LS" => "LSO",
      "LT" => "LTU",
      "JM" => "JAM",
      "GF" => "GUF",
      "AZ" => "AZE",
      "LA" => "LAO",
      "TM" => "TKM",
      "MH" => "MHL",
      "TJ" => "TJK",
      "FR" => "FRA",
      "GG" => "GGY",
      "WF" => "WLF",
      "BZ" => "BLZ",
      "VN" => "VNM",
      "SC" => "SYC",
      "PN" => "PCN",
      "GL" => "GRL",
      "RS" => "SRB",
      "CV" => "CPV",
      "BM" => "BMU",
      "DJ" => "DJI",
      "BV" => "BVT",
      "CK" => "COK",
      "NA" => "NAM",
      "BS" => "BHS",
      "PL" => "POL",
      "HN" => "HND",
      "BF" => "BFA",
      "PF" => "PYF",
      "BR" => "BRA",
      "ER" => "ERI",
      "UG" => "UGA",
      "NE" => "NER",
      "NL" => "NLD",
      "NG" => "NGA",
      "IQ" => "IRQ",
      "BB" => "BRB",
      "PY" => "PRY",
      "IR" => "IRN",
      "CH" => "CHE",
      "UM" => "UMI",
      "TK" => "TKL",
      "TL" => "TLS",
      "YT" => "MYT",
      "CI" => "CIV",
      "SK" => "SVK",
      "WS" => "WSM",
      "AQ" => "ATA",
      "MG" => "MDG",
      "TT" => "TTO",
      "PM" => "SPM",
      "ZW" => "ZWE",
      "DM" => "DMA",
      "RE" => "REU",
      "CM" => "CMR",
      "CC" => "CCK",
      "SZ" => "SWZ",
      "MR" => "MRT",
      "HM" => "HMD",
      "RW" => "RWA",
      "FM" => "FSM",
      "MP" => "MNP",
      "PK" => "PAK",
      "MW" => "MWI",
      "VE" => "VEN",
      "KY" => "CYM",
      "CN" => "CHN",
      "DZ" => "DZA",
      "KM" => "COM",
      "NU" => "NIU",
      "PT" => "PRT",
      "US" => "USA",
      "MS" => "MSR",
      "SO" => "SOM",
      "ES" => "ESP",
      "AM" => "ARM",
      "ML" => "MLI",
      "TC" => "TCA",
      "MM" => "MMR",
      "JE" => "JEY",
      "AO" => "AGO",
      "LV" => "LVA",
      "FJ" => "FJI",
      "UA" => "UKR",
      "BH" => "BHR",
      "EG" => "EGY",
      "ME" => "MNE",
      "AX" => "ALA",
      "MQ" => "MTQ",
      "MX" => "MEX",
      "CX" => "CXR",
      "KH" => "KHM",
      "SV" => "SLV",
      "AS" => "ASM",
      "IN" => "IND",
      "GB" => "GBR",
      "LU" => "LUX",
      "HT" => "HTI",
      "DE" => "DEU",
      "VI" => "VIR",
      "NI" => "NIC",
      "CG" => "COG",
      "ET" => "ETH",
      "CZ" => "CZE",
      "HR" => "HRV",
      "CY" => "CYP",
      "KG" => "KGZ",
      "BO" => "BOL",
      "PG" => "PNG",
      "ZA" => "ZAF",
      "MO" => "MAC",
      "FI" => "FIN",
      "PR" => "PRI",
      "SR" => "SUR",
      "GN" => "GIN",
      "TD" => "TCD",
      "MF" => "MAF",
      "VG" => "VGB",
      "NF" => "NFK",
      "IL" => "ISR",
      "GH" => "GHA",
      "TZ" => "TZA",
      "SH" => "SHN",
      "JO" => "JOR",
      "MV" => "MDV",
      "BE" => "BEL",
      "NC" => "NCL",
      "DK" => "DNK",
      "GS" => "SGS",
      "LB" => "LBN",
      "AI" => "AIA",
      "LI" => "LIE",
      "OM" => "OMN",
      "UY" => "URY",
      "KN" => "KNA",
      "HU" => "HUN",
      "BT" => "BTN",
      "EC" => "ECU",
      "TO" => "TON",
      "NO" => "NOR",
      "RU" => "RUS",
      "MD" => "MDA",
      "SY" => "SYR",
      "DO" => "DOM",
      "MA" => "MAR",
      "HK" => "HKG",
      "SJ" => "SJM",
      "BW" => "BWA",
      "IO" => "IOT",
      "LY" => "LBY",
      "CA" => "CAN",
      "LK" => "LKA",
      "LC" => "LCA",
      "AG" => "ATG",
      "SI" => "SVN",
      "GP" => "GLP",
      "BN" => "BRN",
      "IM" => "IMN",
      "SE" => "SWE",
      "BD" => "BGD",
      "VU" => "VUT",
      "KI" => "KIR",
      "AL" => "ALB",
      "MT" => "MLT",
      "KE" => "KEN",
      "BG" => "BGR",
      "GE" => "GEO",
      "IE" => "IRL",
      "PA" => "PAN",
      "ID" => "IDN",
      "AE" => "ARE",
      "RO" => "ROU",
      "NZ" => "NZL",
      "MN" => "MNG",
      "GY" => "GUY",
      "BL" => "BLM",
      "EE" => "EST",
      "LR" => "LBR",
      "CO" => "COL",
      "CF" => "CAF",
      "MC" => "MCO",
      "CR" => "CRI",
      "AU" => "AUS",
      "ZM" => "ZMB",
      "GT" => "GTM",
      "AF" => "AFG",
      "MK" => "MKD",
      "GD" => "GRD",
      "FK" => "FLK",
      "AD" => "AND",
      "SG" => "SGP",
      "QA" => "QAT",
      "CL" => "CHL",
      "GU" => "GUM",
      "TN" => "TUN",
      "YE" => "YEM",
      "BY" => "BLR",
      "IS" => "ISL",
      "CU" => "CUB",
      "TF" => "ATF",
      "EH" => "ESH"
    }

    COUNTRY_3_TO_2 = COUNTRY_2_TO_3.invert

    def self.country_full_to_3(full_name)
      COUNTRY_2_TO_3[CONTRY_FULL_TO_2[full_name]]
    end

    def self.filter_by_params(keys, params)
      base = self
      keys.each do |key|
        if params[key].present?
          base = base.where(key => params[key])
        end
      end
      base
    end

    def display_path
      return nil if location_url.blank?
      URI.parse(location_url).normalize.path
    end
  end
end
