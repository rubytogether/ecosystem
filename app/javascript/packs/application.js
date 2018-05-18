/* eslint no-console:0 */
import "stylesheets/application.css";

import Chartkick from "chartkick";
import Chart from "chart.js";

window.Chartkick = Chartkick;
Chartkick.addAdapter(Chart);
