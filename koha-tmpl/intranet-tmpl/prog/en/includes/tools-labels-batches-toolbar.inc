<!-- TMPL_IF EXPR="(batch_type eq 'labels')" -->
<div id="toolbar">
	<script type="text/javascript">
	//<![CDATA[

        function Plugin(batch_id) {
	        window.open("label-item-search.pl?batch_id="+batch_id+"",'FindABibIndex','width=640,height=400,toolbar=no,scrollbars=yes');
        }

	// prepare DOM for YUI Toolbar

	 $(document).ready(function() {
	 	$("#additemsc").empty();
	    yuiToolbar();
	 });

	// YUI Toolbar Functions

	function yuiToolbar() {
		new YAHOO.widget.Button({
                                            id: "additems", 
                                            type: "button", 
                                            label: "Add item(s) to batch", 
                                            container: "additemsc",
											onclick: {fn:function(){Plugin(<!-- TMPL_VAR NAME="batch_id" -->)}}
                                        });
		new YAHOO.widget.Button("deletebatch");
		new YAHOO.widget.Button("dedup");
		new YAHOO.widget.Button("generate");
	}

	//]]>
	</script>
	<ul class="toolbar">
	<li id="additemsc"><a id="additems" href="#" onclick="Plugin(<!-- TMPL_VAR NAME="batch_id" -->); return false;">Add item(s) to batch</a></li>
	<li><a id="deletebatch" href="/cgi-bin/koha/labels/label-manager.pl?op=delete_batch&amp;batch_id=<!-- TMPL_VAR NAME="batch_id" -->&amp;type=<!-- TMPL_VAR NAME="batch_type" -->">Delete current batch</a></li>
				<!-- FIXME: should use POST to change server state, not GET -->
	<li><a id="dedup" href="/cgi-bin/koha/labels/label-manager.pl?op=deduplicate&amp;batch_id=<!-- TMPL_VAR NAME="batch_id" -->&amp;type=<!-- TMPL_VAR NAME="batch_type" -->">Remove duplicate barcodes</a></li>
	<li><a id="generate" href="/cgi-bin/koha/labels/label-print-pdf.pl?batch_id=<!-- TMPL_VAR NAME="batch_id" -->&amp;type=<!-- TMPL_VAR NAME="batch_type" -->">Generate PDF for Batch</a></li>
</ul></div>
<!-- TMPL_ELSIF EXPR="(batch_type eq 'patroncards')" -->
<div id="toolbar">
	<script type="text/javascript">
	//<![CDATA[

        function Plugin(batch_id) {
	        window.open("label-patron-search.pl?batch_id="+batch_id+"",'FindABibIndex','width=640,height=400,toolbar=no,scrollbars=yes');
        }

	// prepare DOM for YUI Toolbar

	 $(document).ready(function() {
	 	$("#addpatronsc").empty();
	    yuiToolbar();
	 });

	// YUI Toolbar Functions

	function yuiToolbar() {
		new YAHOO.widget.Button({
                                            id: "addpatrons", 
                                            type: "button", 
                                            label: "Add patron(s) to batch", 
                                            container: "addpatronsc",
											onclick: {fn:function(){Plugin(<!-- TMPL_VAR NAME="batch_id" -->)}}
                                        });
		new YAHOO.widget.Button("deletebatch");
		new YAHOO.widget.Button("dedup");
		new YAHOO.widget.Button("generate");
	}

	//]]>
	</script>
	<ul class="toolbar">
	<li id="addpatronsc"><a id="addpatrons" href="#" onclick="Plugin(<!-- TMPL_VAR NAME="batch_id" -->); return false;">Add item(s) to batch</a></li>
	<li><a id="deletebatch" href="/cgi-bin/koha/labels/label-manager.pl?op=delete_batch&amp;batch_id=<!-- TMPL_VAR NAME="batch_id" -->&amp;type=<!-- TMPL_VAR NAME="batch_type" -->">Delete current batch</a></li>
				<!-- FIXME: should use POST to change server state, not GET -->
	<li><a id="dedup" href="/cgi-bin/koha/labels/label-manager.pl?op=deduplicate&amp;batch_id=<!-- TMPL_VAR NAME="batch_id" -->&amp;type=<!-- TMPL_VAR NAME="batch_type" -->">Remove duplicate barcodes</a></li>
	<li><a id="generate" href="/cgi-bin/koha/labels/label-print-pdf.pl?batch_id=<!-- TMPL_VAR NAME="batch_id" -->&amp;type=<!-- TMPL_VAR NAME="batch_type" -->">Generate PDF for Batch</a></li>
</ul></div>
<!-- /TMPL_IF -->