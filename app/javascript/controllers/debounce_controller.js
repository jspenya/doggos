import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="debounce"
export default class extends Controller {
  connect() { }

  static targets = ["form"]

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      const inputVal = document.querySelector("#dog_breed").value
      fetch("/dogs/search", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
          'Accept': 'text/vnd.turbo-stream.html',
        },
        body: JSON.stringify({ breed: inputVal })
      }).then(response => {
        if (response.ok) {
          return response.text();
        }
        throw new Error('Network response was not ok.');
      }).then(html => {
        Turbo.renderStreamMessage(html);
      }).catch(error => {
        console.error('Error:', error);
      });

    }, 500)
  }

  selectOption(event) {
    const container = document.getElementById('search_results');
    event.preventDefault()

    document.querySelector("#dog_breed").value = event.target.dataset.breed

    while (container.firstChild) {
      container.removeChild(container.firstChild);
    }
  }
}
