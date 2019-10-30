var tree_options = {
    plugins : ["themes", "ui", 'contextmenu', 'crrm', 'dnd', 'hotkeys', 'html_data'],

    themes : { theme : "corral" },
    core : { "initially_open" : [  ], animation : 60 },
    contextmenu : {
      items : {
        create : {
          label	: "Create",
          icon	: "/assets/icons/add.png",
          visible	: function (node) {
            if(node.length != 1) return 0;
            return this.check("creatable", node);
          },
          action	: function (node) {
            this.create(node, 'last');
          },
          separator_after : true
        },
        rename : {
          label	: "Rename",
          icon	: "/assets/icons/edit.png",
          visible	: function (node) {
            if(node.length != 1) return false;
            return this.check("renameable", node);
          },
          action	: function (node) {
            this.rename(node);
          }
        },
        edit : {
          label	: "Edit",
          icon	: "/assets/icons/edit.png",
          visible	: function (node) {
            if(node.length != 1) return false;
            return true;
          },
          action	: function (node) {
            node_id = jQuery(node).attr('id').replace(/navbar-\d+-ni-/, '');
            jQuery('.navbar_form').hide();
            jQuery('.edit_navbar_item').load('/admin/navbar_items/'+node_id+'/edit', function(){
              jQuery(this).prepend("<h2>Editing navbar item</h2>");

              jQuery('.edit_navbar_item form').submit(function() {
                jQuery.post(jQuery(this).attr('action'), jQuery(this).serialize(), function(data) {
                  jQuery('.edit_navbar_item h2 #flash-success').remove();
                  jQuery('.edit_navbar_item h2').append("<span id='flash-success'>Updated successfully</span>");
                  jQuery('.edit_navbar_item h2 #flash-success').fadeOut(3000);
                  reloadJSTree();
                });
                return false;
              });

              jQuery(this).show();
            });
          }
        },
        remove : {
          label	: "Delete",
          icon	: "/assets/icons/delete.png",
          visible	: function (node) {
            var ok = true;
            node_tree = this;
            jQuery.each(node, function() {
              if(node_tree.check("deletable", this) == false) {
                ok = false;
                return false;
              } else { return true; }
            });
            return ok;
          },
          action	: function (node) {
            node_tree = this;
            jQuery.each(node, function () {
              node_tree.remove(this);
            });
          }
        }
      }
    }
  };

function initTree() {
  jQuery(".navbar_wrapper").jstree(tree_options).
    bind('create.jstree', function(e, data) {
      node = data.rslt.obj;
      ref_node = data['args'][0];
      ref_node_id = jQuery(ref_node).attr('id').replace(/navbar-\d+-ni-/, '');
      navbar_id = jQuery(ref_node).attr('id').replace(/navbar-/, '').replace(/-ni-\d+/, '');
      jQuery.post('/admin/navbars/'+navbar_id+'/navbar_items.json', {
          "navbar_item[name]": jQuery.trim(jQuery(node).children('a').text()).replace(/[ ]{2,}/, ' '),
          "navbar_item[navbar_id]": navbar_id,
          "from_tree": true
        }, function(data) {
          node_id = ''+data.id+'';
          jQuery(node).attr('id', 'navbar-'+navbar_id+'-ni-'+node_id+'');
          jQuery.post('/admin/navbars/'+navbar_id+'/update_position', {
            "node": node_id,
            "ref_node": ref_node_id,
            "type": 'inside'
          });
        }
      );

    }).
    bind('rename.jstree', function(e, data){
      node = data.rslt.obj;
      node_id = jQuery(node).attr('id').replace(/navbar-\d+-ni-/, '');
      new_node_name = jQuery.trim(jQuery(node).children('a').text()).replace(/[ ]{2,}/, ' ');
      jQuery.post('/admin/navbar_items/'+node_id+'.js', {
        "_method": "PUT",
        "navbar_item[name]": new_node_name
      });
    }).
    bind('move_node.jstree', function(e, data){
      node = data.args[0].o[0];
      ref_node = data.args[0].r[0];
      type = data.args[0].p;
      navbar_id = jQuery(node).attr('id').replace(/navbar-/, '').replace(/-ni-\d+/, '');
      node_id = jQuery(node).attr('id').replace(/navbar-\d+-ni-/, '');
      ref_node_id = jQuery(ref_node).attr('id').replace(/navbar-\d+-ni-/, '');
      jQuery.post('/admin/navbars/'+navbar_id+'/update_position', {
        "node": node_id,
        "ref_node": ref_node_id,
        "type": type
      });
    }).
    bind('delete_node.jstree', function(e, data){
      node = data.args[0];
      node_id = jQuery(node).attr('id').replace(/navbar-\d+-ni-/, '');
      jQuery.post('/admin/navbar_items/'+node_id+'.js', {
        "_method": "delete"
      });
    });
  jQuery(".navbar_wrapper").jstree("open_all");
}

function reloadJSTree() {
  navbar_id = jQuery('#current-navbar-id').attr('data-navbar-id');
  jQuery(".navbar_wrapper").load('/admin/navbars/'+navbar_id+'/navbar', function() {
    initTree();
  });
}

jQuery(document).ready(function() {
  initTree();

  jQuery('.navbar_form').hide();
  jQuery('a.add_navbar_item').click(function() {
    jQuery('.navbar_form.new_navbar_item form')[0].reset();
    jQuery('.navbar_form.new_navbar_item').show();
	return false;
  });
  jQuery('a.cancel').click(function() {
    jQuery('.navbar_form.new_navbar_item').hide();
	return false;
  });

  jQuery('.new_navbar_item form').submit(function() {
    jQuery.post(jQuery(this).attr('action'), jQuery(this).serialize(), function(data) {
      jQuery('.new_navbar_item h2 #flash-success').remove();
      jQuery('.new_navbar_item h2').append("<span id='flash-success'>Created successfully</span>");
      jQuery('.new_navbar_item h2 #flash-success').fadeOut(3000);
      reloadJSTree();
    });
    return false;
  });
});
