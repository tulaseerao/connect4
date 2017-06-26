$(document).ready(function(){
  $('div.board-cell').click(function(){
    id  = this.id;
    id  = id.split("_");
    id  = id[id.length-1];
    $('#pick_column').val(id);
    $("#pick_form").submit();
    $("#pick_form").attr('action', window.location.href);
    $("#pick_form").attr('method', 'GET');
  });
});
