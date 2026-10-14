document.addEventListener("turbo:load", function () {
  window.Stimulus.register(
    "tab-frame",
    class extends window.StimulusController {
      static targets = ["frame"];

      load() {
        if (!this.frameTarget.src) {
          this.frameTarget.src = this.frameTarget.dataset.src;
        }
      }
    }
  );
});
