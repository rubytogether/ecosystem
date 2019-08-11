/* eslint no-console:0 */
import "stylesheets/application.css";

import jQuery from "jquery";
import ApexCharts from "apexcharts";
import Rails from "rails-ujs";

Rails.start();

window.jQuery = jQuery;
window.ApexCharts = ApexCharts;
window.Rails = Rails;
