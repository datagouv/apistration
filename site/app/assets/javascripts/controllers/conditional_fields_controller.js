document.addEventListener("turbo:load", function () {
  window.Stimulus.register(
    "conditional-fields",
    class extends window.StimulusController {
      static targets = ["field"];
      static values = { name: String };

      connect() {
        this.toggle();
      }

      toggle() {
        const checked = this.element.querySelector(`input[name="${this.nameValue}"]:checked`);
        const value = checked ? checked.value : "";

        this.fieldTargets.forEach((field) => {
          field.hidden = !field.dataset.showWhen.split(" ").includes(value);
        });
      }
    }
  );
});
