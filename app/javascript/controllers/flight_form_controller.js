import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["capacity", "aircraft", "capacityInfo"];

  connect() {
    this.updateCapacityInfo();
  }

  updateCapacityInfo() {
    const aircraftSelect = this.aircraftTarget;
    const capacityInput = this.capacityTarget;
    const capacityInfo = this.capacityInfoTarget;
    const selectedAircraft = aircraftSelect.value;
    const capacities = JSON.parse(capacityInput.dataset.aircraftCapacity);

    if (selectedAircraft && capacities[selectedAircraft]) {
      const maxCapacity = capacities[selectedAircraft];
      capacityInfo.textContent = `Maximum capacity: ${maxCapacity} passengers`;
      capacityInput.max = maxCapacity;
    } else {
      capacityInfo.textContent = "Select an aircraft to see its capacity";
      capacityInput.max = "";
    }
  }
}
