document.addEventListener("turbo:load", function () {
  window.Stimulus.register(
    "frame-reload",
    class extends window.StimulusController {
      static values = { delay: { type: Number, default: 3000 } };

      connect() {
        this.frame = this.element.closest("turbo-frame");
        this.scheduleReload = this.scheduleReload.bind(this);
        this.frame.addEventListener("turbo:fetch-request-error", this.scheduleReload);
        this.scheduleReload();
      }

      disconnect() {
        clearTimeout(this.timeout);
        this.frame.removeEventListener("turbo:fetch-request-error", this.scheduleReload);
      }

      scheduleReload() {
        clearTimeout(this.timeout);
        this.timeout = setTimeout(() => this.frame.reload(), this.delayValue);
      }
    }
  );
});
