function get_current_url() {
    var url = window.location.href 
    return url;
}

function get_code_challenge(verifier) {
    generateChallenge(verifier);
    return 0;
}

function base64UrlEncode(array) {
    return btoa(String.fromCharCode.apply(null, new Uint8Array(array)))
        .replace(/\+/g, '-')
        .replace(/\//g, '_')
        .replace(/=+$/, '');
}

function generateChallenge(verifier) 
{
    const encoder = new TextEncoder();
    const data = encoder.encode(verifier);
    window.crypto.subtle.digest('SHA-256', data).then(array => { 
       const challenge = base64UrlEncode(array); 
       var data = {};
       data.type = "youre_challenge_generator";
       data.challenge = challenge;
       GMS_API.send_async_event_social(data);
    });
}

