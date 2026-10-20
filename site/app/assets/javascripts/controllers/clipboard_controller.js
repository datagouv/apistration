document.addEventListener("turbo:load", function () {
  window.Stimulus.register(
    "clipboard",
    class extends window.StimulusController {
      static targets = ["source"];
      static values = {
        alertMessage: String,
      };

      copy() {
        const masked = this.sourceTarget.type === "password";

        if (masked) {
          this.sourceTarget.type = "text";
        }

        try {
          this.sourceTarget.select();
          document.execCommand("copy");
        } finally {
          if (masked) {
            this.sourceTarget.type = "password";
            this.sourceTarget.setSelectionRange(0, 0);
          }
        }

        if (this.hasAlertMessageValue) {
          alert(this.alertMessageValue);
        }
      }
    }
  );
});
