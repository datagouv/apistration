document.addEventListener("turbo:load", function () {
  window.Stimulus.register(
    "chart-download",
    class extends window.StimulusController {
      static targets = ["chart"];
      static values = { title: String };

      download(event) {
        event.preventDefault();
        const chart = this.chartTarget.querySelector(
          "line-chart, bar-chart"
        );
        if (!chart) return;

        const xData = JSON.parse(chart.getAttribute("x"));
        const yData = JSON.parse(chart.getAttribute("y"));
        const names = JSON.parse(chart.getAttribute("name"));
        const labels = xData[0] || [];
        const sep = ";";
        const bom = "﻿";

        const header = [
          "",
          ...names.map((n) => '"' + n.replace(/"/g, '""') + '"'),
        ].join(sep);
        const rows = labels.map((label, i) => {
          const values = yData.map((series) => series[i] ?? "");
          return ['"' + label.replace(/"/g, '""') + '"', ...values].join(sep);
        });

        const csv = bom + [header, ...rows].join("\n") + "\n";
        const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
        const url = URL.createObjectURL(blob);
        const a = document.createElement("a");
        a.href = url;
        a.download =
          (this.titleValue || "chart").replace(/[^a-zA-Z0-9À-ÿ _-]/g, "") +
          ".csv";
        a.click();
        URL.revokeObjectURL(url);
      }
    }
  );
});
