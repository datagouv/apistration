document.addEventListener("turbo:load", function () {
  window.Stimulus.register(
    "batch-selection",
    class extends window.StimulusController {
      static targets = ["checkbox", "submit"];

      update() {
        const count = this.checkboxTargets.filter((checkbox) => checkbox.checked).length;

        this.submitTarget.textContent = count === 1 ? "Signer la demande" : `Signer les ${count} demandes`;
        this.submitTarget.disabled = count === 0;
      }
    },
  );
});
