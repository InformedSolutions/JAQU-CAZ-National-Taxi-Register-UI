var config = {
    defaults: {
        standard: 'WCAG2AA',
        // ignore issue with role=presentation on start button
        ignore: ["WCAG2AA.Principle1.Guideline1_3.1_3_1.F92,ARIA4"],
        timeout: 5000,
        wait: 1500,
        chromeLaunchConfig: {
            args: [
                "--no-sandbox"
            ]
        },
        hideElements: [".govuk-header__logotype-crown", ".govuk-footer__licence-logo"]
    },
    urls: [
        '${BASE_URL}',
        '${BASE_URL}/cookies',
        {
            "url": '${BASE_URL}',
            "actions": [
                "set field #user_username to edmond.chhung@informed.com",
                "set field #user_password to Edc123.,",
                "click element input[type=submit]",
                "wait for element #file-upload-1 to be visible"

            ]
        }
    ]
};

/**
 * Simple method to replace nested URLs in a pa11y configuration definition
 */
function replacePa11yBaseUrls(urls, defaults) {

    console.error('BASE_URL:', process.env.BASE_URL);

    //Iterate existing urls object from configuration
    for (var idx = 0; idx < urls.length; idx++) {
        if (typeof urls[idx] === 'object') {
            // If configuration object in URLs is a further nested object, replace inner url field value
            var nestedObject = urls[idx]
            nestedObject['url'] = nestedObject['url'].replace('${BASE_URL}', process.env.BASE_URL)
            urls[idx] = nestedObject;
        } else {
            // Otherwise replace simple string (see pa11y configuration guidance)
            urls[idx] = urls[idx].replace('${BASE_URL}', process.env.BASE_URL);
        }
    }

    result = {
        defaults: defaults,
        urls: urls
    }

	console.log('\n')
	console.log('Generated pa11y configuration:\n')
	console.log(result)
	
    return result
};

module.exports = replacePa11yBaseUrls(config.urls, config.defaults);
