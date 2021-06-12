require("@rails/ujs").start();
import '../styles/application.scss';
import '../src/GovUKAssets';
import { initAll } from 'govuk-frontend/govuk/all.js';
import cookieControl from "../src/cookieControl";
import initBackLink from "../src/backLink/init";

document.body.classList.add('js-enabled');
initAll();
cookieControl();
initBackLink();
