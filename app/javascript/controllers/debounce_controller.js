import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="debounce"
export default class extends Controller {
  connect() { }

  static targets = ["form", "breedOption", "breedInput", "searchResults"]

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      fetch("/dogs/search", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
          'Accept': 'text/vnd.turbo-stream.html',
        },
        body: JSON.stringify({ breed: this.breedInputTarget.value })
      }).then(response => {
        if (response.ok) {
          return response.text()
        }
        throw new Error('Network response was not ok.')
      }).then(html => {
        Turbo.renderStreamMessage(html)
      }).catch(error => {
        console.error('Error:', error)
      })

    }, 500)
  }

  selectOption(event) {
    const container = this.searchResultsTarget
    event.preventDefault()

    this.breedInputTarget.value = this.breedOptionTarget.dataset.breed
    this.formTarget.requestSubmit()

    while (container.firstChild) {
      container.removeChild(container.firstChild)
    }
  }
}
