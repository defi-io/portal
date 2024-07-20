import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  calcalate() {

	const url = "/calcalate?amount=" + amount.value + "&from=" + from.value + "&to=" + to.value;
	
	if(from_valid.value == 'false' || to_valid.value == 'false'){
		event.preventDefault();
	}else{
	    fetch(url)
	      .then(response => response.text())
	      .then(html => convert.innerHTML = html)
		coin_ul.innerHTML = '';
		currency_ul.innerHTML = '';
	}
  }
  
  search_coin() {
	const url = "/search-coin?from=" + from.value
	
    fetch(url)
      .then(response => response.text())
      .then(html => coin_list.innerHTML = html)
  }
  
  choose_coin(){
    const targetElement = event.target;
	from.value = targetElement.textContent;
	this.calcalate();
	coin_ul.innerHTML = '';
  }
  
  auto_select(){
	  try {
	    const coin = coin_0.textContent;
	  	from.value = coin;
	  	coin_ul.innerHTML = '';
	  	this.calcalate(); 	
		} catch (error) {
		  // console.error('Not exist', error);
	  }
  }
  
  search_currency(){
  	const url = "/search-currency?to=" + to.value
	
	  fetch(url)
	    .then(response => response.text())
	    .then(html => currency_list.innerHTML = html)
  }
  
  choose_currency(){
    const targetElement = event.target;
  	to.value = targetElement.textContent;
  	this.calcalate();
  	currency_ul.innerHTML = '';
  }
  
  auto_clear(){
  	try {
	  	to.value = currency_0.textContent;
	  	this.calcalate(); 	
	  	coin_ul.innerHTML = '';
	  	currency_ul.innerHTML = '';
	} catch (error) {
		// console.error('Not exist', error);
	}
  }
  
}