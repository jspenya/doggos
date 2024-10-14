import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="debounce"
export default class extends Controller {
  static dogs = ['names']
  static targets = ["form", "breedOption", "breedInput", "searchResults"]

  connect() {
    fetch('/dogs.json')
      .then(response => response.json())
      .then(dogNames => {
        this.dogsNames = dogNames
      })
      .catch(error => {
        console.error("Error fetching dog names:", error)
      })
  }

  search() {
    const searchQuery = this.breedInputTarget.value.toLowerCase()
    if (searchQuery === '') {
      return
    }

    const filteredDogs = this.dogsNames.filter(dog =>
      dog.toLowerCase().includes(searchQuery)
    )

    this.updateSearchResults(filteredDogs)
  }

  updateSearchResults(dogs) {
    const container = this.searchResultsTarget
    container.innerHTML = ''

    if (dogs.length === 0) {
      container.innerHTML = '<p>No matching breeds found.</p>'
      return
    }

    dogs.forEach(dog => {
      const div = document.createElement('div')
      div.classList.add('my-2')

      const link = document.createElement('a')
      link.textContent = dog
      link.href = "#"
      link.dataset.action = "click->debounce#selectOption"
      link.dataset.debounceTarget = "breedOption"
      link.dataset.breed = dog
      link.dataset.turbo = "true"

      div.appendChild(link)
      container.appendChild(div)
    })
  }

  selectOption(event) {
    const container = this.searchResultsTarget
    event.preventDefault()

    this.breedInputTarget.value = event.target.dataset.breed
    this.formTarget.requestSubmit()

    while (container.firstChild) {
      container.removeChild(container.firstChild)
    }
  }
}
