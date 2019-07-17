import './styles.scss'

const cookieKey = 'seen_cookie_message';
const dayInMS = (1000 * 60 * 60 * 24);
const yearInMS = dayInMS * 365 ;

function init() {
    if(!hasSeenMessage()){
        const banner = document.getElementById('global-cookie-message');
        banner.style.display = 'block';
        const closeLink = banner.querySelector('#close-banner');
        closeLink.addEventListener('click', () => {
            banner.style.display = 'none';
            setCookie()
        })
    }
}

function hasSeenMessage(){
    return document.cookie.indexOf(cookieKey + '=true') > -1
}

function setCookie(){
    const date = new Date();
    date.setTime(date.getTime() + yearInMS);
    document.cookie = cookieKey + '=true; expires=' + date.toGMTString();
}

export default init;
