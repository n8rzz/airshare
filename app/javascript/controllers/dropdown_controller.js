import { Controller } from "@hotwired/stimulus";

// @TODO: use css instead of javascript
export default class extends Controller {
  static targets = ["menu"];

  connect() {
    this.menuTarget.classList.add("hidden");
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden");
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }
}
