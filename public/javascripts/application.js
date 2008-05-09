Event.onReady(function() {
  ['notice', 'errors'].each(function(flashType) {
    var elem = $('flash-' + flashType);
    if (elem.innerHTML != '') Flash.show(flashType, elem.innerHTML);
  });
});

/*-------------------- Flash ------------------------------*/
// Flash is used to manage error messages and notices from 
// Ajax calls.
//
var Flash = {
  // When given an flash message, wrap it in a list 
  // and show it on the screen.  This message will auto-hide 
  // after a specified amount of milliseconds
  show: function(flashType, message) {
    new Effect.ScrollTo('flash-' + flashType);
    $('flash-' + flashType).innerHTML = '';
    if (message.toString().match(/<li/)) message = "<ul>" + message + '</ul>'
    $('flash-' + flashType).innerHTML = message;
    new Effect.Appear('flash-' + flashType, {duration: 0.3});
    setTimeout(Flash['fade' + flashType[0].toUpperCase() + flashType.slice(1, flashType.length)].bind(this), 5000)
  },
  
  errors: function(message) {
    this.show('errors', message);
  },

  // Notice-level messages.  See Messenger.error for full details.
  notice: function(message) {
    this.show('notice', message);
  },
  
  // Responsible for fading notices level messages in the dom    
  fadeNotice: function() {
    new Effect.Fade('flash-notice', {duration: 0.3});
  },
  
  // Responsible for fading error messages in the DOM
  fadeErrors: function() {
    new Effect.Fade('flash-errors', {duration: 0.3});
  }
}

var TableSorter = Class.create();
TableSorter.prototype = {
  initialize: function(sortableId, updateUrl, itemName) {
    Sortable.create(sortableId, { 
      tag: 'li', 
      handle: 'handle',
      onUpdate: function(list) {
        new Ajax.Request(updateUrl, {
          asynchronous: true, 
          evalScripts:  true, 
          parameters:   Sortable.serialize(list, { name: itemName }),
          method: 'put'
        }); 
      }
    });
  } 
}

Event.addBehavior({
  '#linklist': function() { window.linkSorter = new TableSorter('linklist', '/admin/links/reorder', 'links') },
  '#newslist': function() { window.linkSorter = new TableSorter('newslist', '/admin/news_items/reorder', 'news_items') }
});
