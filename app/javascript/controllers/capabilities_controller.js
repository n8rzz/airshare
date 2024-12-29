import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  toggleGuest(event) {
    const isGuest = event.target.checked;
    const pilotCheckbox = document.getElementById("Pilot");
    const passengerCheckbox = document.getElementById("Passenger");

    if (isGuest) {
      pilotCheckbox.checked = false;
      passengerCheckbox.checked = false;
      pilotCheckbox.disabled = true;
      passengerCheckbox.disabled = true;
    } else {
      pilotCheckbox.disabled = false;
      passengerCheckbox.disabled = false;
    }

    // Ensure the form is submitted with the correct guest status
    const guestHiddenInput = document.querySelector(
      'input[name="user[guest]"][type="hidden"]'
    );
    if (guestHiddenInput) {
      guestHiddenInput.value = isGuest ? "1" : "0";
    }
  }
}
