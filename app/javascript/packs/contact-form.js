function displayAddContactForm() {
  const contactForm = document.getElementById('add-contact');
  contactForm.style.display = "flex";
}

document.querySelector('.new-chat').addEventListener('click', displayAddContactForm);

function hideContactFormWhenScrolled() {
  var prevScrollpos = window.pageYOffset;
  window.onscroll = function() {
    const currentScrollPos = window.pageYOffset;
    if (prevScrollpos > currentScrollPos) {
      const contactForm = document.getElementById("add-contact");
      contactForm.style.display = "none";
    }
    prevScrollpos = currentScrollPos;
  }
}

hideContactFormWhenScrolled();
