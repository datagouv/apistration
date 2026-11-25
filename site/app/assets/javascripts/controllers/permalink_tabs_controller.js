document.addEventListener("turbo:load", function () {
  window.Stimulus.register(
    "permalink-tabs",
    class extends window.StimulusController {
      static values = { param: String };

      select(event) {
        const url = new URL(window.location.href);

        url.searchParams.set(this.paramValue, event.currentTarget.dataset.tabKey);
        window.history.replaceState(window.history.state, "", url);
      }
    }
  );
});
