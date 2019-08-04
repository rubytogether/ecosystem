/* eslint no-console:0 */
import "rickshaw/rickshaw.css";
import "stylesheets/application.css";

import Rickshaw from "rickshaw/rickshaw.js";
import jQuery from "jquery";
import ApexCharts from "apexcharts";
import Rails from "rails-ujs";

Rails.start();

window.jQuery = jQuery;
window.Rickshaw = Rickshaw;
window.ApexCharts = ApexCharts;
window.Rails = Rails;
