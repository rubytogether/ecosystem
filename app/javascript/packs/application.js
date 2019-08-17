/* eslint no-console:0 */
import "stylesheets/application.scss";

import jQuery from "jquery";
import ApexCharts from "apexcharts";
import Rails from "rails-ujs";
require.context("../../assets/images", false, /\.(png|jpe?g|svg)$/);

Rails.start();

window.jQuery = jQuery;
window.ApexCharts = ApexCharts;
window.Rails = Rails;
