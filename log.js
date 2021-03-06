/*
 * $Id$
 * Copyright 2004-2006 - Michael Sinz
 *
 * Some JavaScript support routines for the svn log pages
 */

// Store references to the details objects here
var revs = new Array();

/*
 * Get the detail element by the revision
 */
function getDetail(rev)
{
	return (document.getElementById(':' + rev));
}

/*
 * Get the specific file detail element by path and revision
 */
function getPathDetail(path,rev)
{
	return (document.getElementById(path + ':' + rev));
}

/*
 * This is used to toggle a given hidden element
 */
function toggle(rev)
{
	var div=getDetail(rev);
	if (div)
	{
		if (!div.editButton)
		{
			if (div.style.display == "none")
			{
				div.style.display = "";
			}
			else
			{
				div.style.display = "none";
			}
		}
	}
}

/*
 * Clear any timeouts that this div may have
 * active...
 */
function clearTimeouts(div)
{
	if (div.slider)
	{
		clearTimeout(div.slider);
		div.slider = null;
	}
	if (div.timer)
	{
		clearTimeout(div.timer);
		div.timer = null;
	}
}

// Keep track of any open popup object here
var openedPopup;

/*
 * Hide the currently open popup but only if
 * there is a timer set on it or I was told
 * to do it by force.
 */
function hidePopup(force)
{
	if ((openedPopup) && (force || (openedPopup.timer)))
	{
		var div = openedPopup;
		openedPopup = null;

		clearTimeouts(div);
		div.showing = 0;
		div.style.display = 'none';
		div.parentNode.style.background = 'transparent';
	}
}

/*
 * This will show a given popup by first making sure
 * that the old popup is gone and then by setting up
 * the new popup.  A timer is set such that if the
 * popup is not entered by the mouse within 5 seconds,
 * it will be removed.
 */
function showPopup(div)
{
	if (div != openedPopup)
	{
		// Force the old popup to go away, if needed.
		hidePopup(true);

		// Note that this colour should match the stylesheet background for the div...
		div.parentNode.style.background = 'rgb(100%,100%,75%)';

		// Set this one to be showing...
		div.showing = 1;
		div.sliding = 0;
		openedPopup = div;

		// Clear any timeouts...
		clearTimeouts(div);

		// take down the popup if the user has not entered it in 5 seconds.
		div.timer = setTimeout('hidePopup()',5000);

		// Start the sliding open process...
		div.slider = setTimeout('slideOpen()',10);

		// Try to initialize the clipping area...
		div.style.clip = 'rect(auto,auto,auto,auto)';
	}
}

/*
 * Some silly visual candy for sliding/unfolding the menu
 * onto screen rather than just pop up instantly.
 */
function slideOpen()
{
	var div = openedPopup;
	if (div.style.clip)
	{
		div.sliding++;
		if (div.sliding >= Insurrection.SliderSteps)
		{
			// No more timeouts we are done...
			div.slider = null;

			// No more clipping needed...
			div.style.clip = 'rect(auto,auto,auto,auto)';
		}
		else
		{
			var clipx = Math.floor((div.offsetWidth * div.sliding) / Insurrection.SliderSteps);
			var clipy = Math.floor((div.offsetHeight * div.sliding) / Insurrection.SliderSteps);

			div.style.clip = 'rect(auto,' + clipx + 'px,' + clipy + 'px,auto)';

			// Ok, we want to do this again since we are not done yet...
			div.slider = setTimeout('slideOpen()',10);
		}
	}

	div.style.display = 'block';
}

/*
 * This is called in the onmouseout for the popup and will cause
 * a 500ms timer to run.  If the mouse does not reenter the popup
 * within that timeout, the popup will be torn down.
 */
function offPopup(div)
{
	// If the mouse leaves the popup, take it down in 1/2 second.
	div.timer = setTimeout('hidePopup()',500);
}

/*
 * This is called in the onmouseover for the popup and will cause
 * any still active timers to be cleared.  This is how a popup stays
 * in place if the user has the mouse over it.
 */
function onPopup(div)
{
	// If there is a takedown timer set, clear it if the
	// mouse enters the area.
	if (div.timer)
	{
		clearTimeout(div.timer);
		div.timer = null;
	}
}

// Get the initial state of the diff selection from the
// cookies such that a selection can live across pages.
var diffPath = GetCookie('diffPath');
var diffRev = GetCookie('diffRev');
if ((diffPath == null) || (diffPath == '') || (diffRev == null) || (diffRev == 0))
{
	diffPath = '';
	diffRev = 0;
}

/*
 * Set the browser status bar with the diff selection info
 * if there is a selected file for diff.
 */
function setSelectMessage()
{
	if ((diffPath != '') && (diffRev != 0))
	{
		// Set a message about the fact that a revision was selected...
		var msg = diffPath + ' revision ' + diffRev + ' selected for diff';
		window.defaultStatus = msg;
		window.status = msg;
	}
}

// Set status at load time (in case there is a cookie already)
setSelectMessage();

/*
 * Select a given path and revision for future diff operation
 */
function selectForDiff(path,rev)
{
	diffPath = path;
	diffRev = rev;

    // Limit the revision cookie to this repository
    cookiePath = Insurrection.SVN_URL + path.substring(0,path.indexOf('/'));
	SetTempCookie('diffPath',path,cookiePath);
	SetTempCookie('diffRev',rev,cookiePath);
	setSelectMessage();
}

/*
 * Add a popup menu item line to the given element.
 * This is used by the addLink() function and directly
 * to add text without a link.
 */
function addPopupLine(el,text)
{
	var d1 = document.createElement('div');
	d1.className = 'pathpopupmenuitem';
	el.appendChild(d1);

	d1.appendChild(document.createTextNode(text));
}

/*
 * A simple function to build a link with a given URL
 * and link text for the popup menu.
 */
function addLink(div,link,text)
{
	var a = document.createElement('a');
	a.href = link;
	div.appendChild(a);

	var d1 = document.createElement('div');
	d1.className = 'pathpopupmenuitem';
	d1.title = text;
	a.appendChild(d1);

	d1.appendChild(document.createTextNode(text));
}

/*
 * Create a menu segment element and, optionally,
 * add it to the provided parent element.
 */
function newSegment(parent)
{
	var div = document.createElement('div');
	div.className = 'menusegment';
	if (parent)
	{
		parent.appendChild(div);
	}
	return(div);
}

/*
 * When we click on a detailed log entry path line,
 * we get a popup menu that lists certain actions,
 * depending on the commit event for the line.
 * We build the correct URLs that will then execute
 * that operation.
 */
function detailClick(repo,action,path,rev,current)
{
	var div = getPathDetail(path,rev);

	if (div)
	{
		if ((div.diffPath != diffPath) || (div.diffRev != diffRev))
		{
			div.diffPath = diffPath;
			div.diffRev = diffRev;
			div.innerHTML = '';

			var d1 = document.createElement('div');
			d1.className = 'pathpopupshadow';
			div.appendChild(d1);
			var d2 = document.createElement('div');
			d2.className = 'pathpopupmenu';
			d1.appendChild(d2);

			var fullpath = repo + path;

			if (action != 'D')
			{
				addLink(d2,Insurrection.SVN_URL + fullpath + '?Insurrection=blame&r=' + rev,'Annotate');
				addLink(d2,Insurrection.SVN_URL + fullpath + '?Insurrection=get&r=' + rev,'Download');

				if ((diffPath == fullpath) && (diffRev == rev))
				{
					d1 = document.createElement('div');
					d1.className = 'pathpopupmenutext';
					d1.appendChild(document.createTextNode('-- Selected/Marked revision --'));
					d1.title = 'Selected/Marked revision';

					d2.appendChild(d1);
				}
				else
				{
					var a = document.createElement('a');
					d2.appendChild(a);

					a.href='javascript:;';
					a['onclick'] = function() { eval('selectForDiff("' + fullpath + '","' + rev + '");'); }

					d1 = document.createElement('div');
					d1.className = 'pathpopupmenuitem';
					a.appendChild(d1);

					d1.appendChild(document.createTextNode('Select/Mark this revision'));
					d1.title = 'Select/Mark this revision';
				}

				var dDiff = newSegment();
				var dPatch = newSegment();

				if (action == 'M')
				{
					addLink(dDiff,Insurrection.SVN_URL + fullpath + '?Insurrection=diff&r=' + rev + '&r2=' + rev + '&r1=' + (rev-1),'Diff from previous');
					addLink(dPatch,Insurrection.SVN_URL + fullpath + '?Insurrection=diff&getpatch=1&r=' + rev + '&r2=' + rev + '&r1=' + (rev-1),'Patch from previous');
				}

				if (diffPath == fullpath)
				{
					if (diffRev < rev)
					{
						addLink(dDiff,Insurrection.SVN_URL + fullpath + '?Insurrection=diff&r=' + rev + '&r1=' + diffRev + '&r2=' + rev,'Diff from selected revision: ' + diffRev);
						addLink(dPatch,Insurrection.SVN_URL + fullpath + '?Insurrection=diff&getpatch=1&r=' + rev + '&r1=' + diffRev + '&r2=' + rev,'Patch from selected revision: ' + diffRev);
					}

					if (diffRev > rev)
					{
						addLink(dDiff,Insurrection.SVN_URL + fullpath + '?Insurrection=diff&r=' + rev + '&r2=' + diffRev + '&r1=' + rev,'Diff to selected revision: ' + diffRev);
						addLink(dPatch,Insurrection.SVN_URL + fullpath + '?Insurrection=diff&getpatch=1&r=' + rev + '&r2=' + diffRev + '&r1=' + rev,'Patch to selected revision: ' + diffRev);
					}
				}

				if ((rev != current) && ((diffPath != fullpath) || (diffRev != current)))
				{
					addLink(dDiff,Insurrection.SVN_URL + fullpath + '?Insurrection=diff&r=' + rev + '&r2=' + current + '&r1=' + rev,'Diff to revision ' + current);
					addLink(dPatch,Insurrection.SVN_URL + fullpath + '?Insurrection=diff&getpatch=1&r=' + rev + '&r2=' + current + '&r1=' + rev,'Patch to revision ' + current);
				}

				if (dDiff.childNodes.length > 0)
				{
					d2.appendChild(dDiff);
				}

				if (dPatch.childNodes.length > 0)
				{
					d2.appendChild(dPatch);
				}

				if (action == 'M')
				{
					addLink(newSegment(d2),Insurrection.SVN_URL + fullpath + '?Insurrection=log&r1=' + rev,'Revision history from ' + rev);
				}
			}
			else
			{
				rev--;
				addLink(d2,Insurrection.SVN_URL + fullpath + '?Insurrection=blame&r=' + rev,'Annotate previous');
				addLink(d2,Insurrection.SVN_URL + fullpath + '?Insurrection=get&r=' + rev,'Download previous');
				addLink(d2,Insurrection.SVN_URL + fullpath + '?Insurrection=log&r1=' + rev,'Revision history from ' + rev);
				rev++;
			}

			if (rev > 1)
			{
				d1 = newSegment(d2);
				addLink(d1,Insurrection.SVN_URL + repo + '/?Insurrection=diff&r=' + rev + '&r2=' + rev + '&r1=' + (rev-1),'Changeset for this revision');
				addLink(d1,Insurrection.SVN_URL + repo + '/?Insurrection=diff&getpatch=1&r=' + rev + '&r2=' + rev + '&r1=' + (rev-1),'Patchset for this revision');
			}

		}
		showPopup(div);
	}

	return true;
}

/*
 * This is some JavaScript to provide the feature of showing and hiding details
 * Note that we do some fun stuff to show the details slowly as it really takes
 * a long time in some cases where there are many revisions in the history.
 * This is why we do much of this work async...
 */

// This will store the reference to the show/hide
// details button.  It should be set by the loading
// process.
var details;

/*
 * This method adds detail log sections to the array of details.
 * It also updates the details button such that it shows that
 * you can show/hide the details.  Note that if there is no
 * details section, it does not add it, which could mean that
 * the SVN LOG was not done with verbose output.  This keeps all
 * of this compatible with both forms.
 */
function addDetail(id)
{
	var div=getDetail(id);
	if (div)
	{
		if (!details)
		{
			details = document.getElementById('details');
		}

		// Since we had some details, we should show
		// the fact that you can display them...
		if (details)
		{
			revs.push(div);

			// For the first details entry, show it by default
			if (revs.length == 1)
			{
				div.style.display = "";
			}

			// If there is more than one details entry, show the
			// "click to show" text.
			if (revs.length > 1)
			{
				details.innerHTML = 'click to show details';
				details.showhide = 'show';
			}
		}
	}
}

/*
 * This function shows detail sections by calling itself
 * from a timer every 50ms until it has shown all sections.
 * This starts at a low index and moves up.
 */
function showDetails(i)
{
	if (i < revs.length)
	{
		revs[i].style.display = "";
		i++;
		setTimeout('showDetails(' + i + ')',50);
		details.innerHTML = '...showing ' + i;
	}
	else
	{
		details.innerHTML = 'click to hide details';
		details.showhide = 'hide';
	}
}

/*
 * This function hides detail sections by calling itself
 * from a timer every 50ms until it has hidden all sections.
 * This starts at a high index and moves down.
 */
function hideDetails(i)
{
	if (i > 0)
	{
		i--;
		revs[i].style.display = "none";
		setTimeout('hideDetails(' + i + ')',50);
		details.innerHTML = '...hiding ' + i;
	}
	else
	{
		details.innerHTML = 'click to show details';
		details.showhide = 'show';
	}
}

/*
 * When the show all/hide all is clicked, we start
 * the process rolling.
 */
function toggleAll()
{
	// Only if we have the details feature and
	// we have more than 1 revision do we support
	// the toggle feature.
	if ((details) && (revs.length > 1))
	{
		if (details.showhide != 'working')
		{
			if (details.showhide == 'hide')
			{
				hideDetails(revs.length);
			}
			else
			{
				showDetails(0);
			}

			details.showhide = 'working';
		}
	}
}

/*
 * Get the value of a named cookie.  We use
 * these cookies to get/set configuration like
 * elements without the need for server interaction.
 */
function GetCookie(name)
{
    var arg = name + "=";
    var alen = arg.length;
    var clen = document.cookie.length;
    var i = 0;

    while (i < clen)
    {
        var j = i + alen;
        if (document.cookie.substring(i, j) == arg)
        {
            var endstr = document.cookie.indexOf (";", j);
            if (endstr == -1)
            {
                endstr = document.cookie.length;
            }
            return unescape(document.cookie.substring(j, endstr));
        }

        i = document.cookie.indexOf(" ", i) + 1;

        if (i == 0)
        {
            return null;
        }
    }
    return null;
}

/*
 * Set a session-temporary cookie...
 * Setting a cookie is just too easy...  Too bad getting the
 * cookie is not as easy.
 */
function SetTempCookie(name, value, path)
{
    document.cookie = name + '=' + escape(value) + '; path=' + path;
}

/*
 * Setting a cookie is just too easy...  Too bad getting the
 * cookie is not as easy.
 */
function SetCookie(name, value)
{
	// Ugly trick - we build a cookie expires string
	// that is set for 1 year from "now" such that the
	// cookies remain valid for more than a single session.
	var Expires = new Date();
	Expires.setYear(Expires.getYear() + 1901);
	var CookieExpires = '; expires=' + Expires.toGMTString();

    document.cookie = name + '=' + escape(value) + CookieExpires + '; path=/';
}

/*
 * Start the editing process for a given log message.
 * This displays the textarea that will be used for the
 * edit work and hides the edit button since we are now
 * in active editing mode.  We also read the log message
 * from the <div> that it is within in order that we
 * start with the same message as was being displayed.
 * (less overhead to the server)
 */
function editLog(edit,rev)
{
	// This ugly little thing here is to force the other click
	// that is going to be registered to show the list of paths
	// for this revision.  This way the log editing will be
	// done with the revisions showing...
	var details = getDetail(rev);
	details.style.display = '';

	// remember the edit button and hide it...
	details.editButton = edit;
	edit.style.display = 'none';

	// Get our log message since we are going to edit it...
	// This lets the browser deal with correct scaping of the nodes
	var log = document.getElementById('Log:' + rev);

	var t = log.firstChild;
	var msg = '';
	while (t)
	{
		if (t.nodeName == '#text')
		{
			msg += t.nodeValue;
		}
		else
		{
			msg += "\n";
		}
		t = t.nextSibling;
	}

	// Set up the edit textarea with the current log message
	var ed = document.getElementById('LogEd:' + rev);
	ed.value = msg;

	// remember to save the original in order to support cancel
	ed.original = msg + '';

	document.getElementById('LogEdit:' + rev).style.display='block';
}

/*
 * Take the msg string and put it into the log message
 * display for the given revision.  This converts any "\n"
 * in the string into "<br/>" HTML/DOM elements.
 */
function showLog(rev,msg)
{
	var log = document.getElementById('Log:' + rev);
	log.innerHTML = '';	// Cear out the old log...

	// start putting the message into the log element
	var i;
	while((i = msg.indexOf("\n")) >= 0)
	{
		if (i > 0)
		{
			log.appendChild(document.createTextNode(msg.substr(0,i)));
		}
		msg = msg.substr(i+1);
		log.appendChild(document.createElement('br'));
	}
	if (msg.length > 0)
	{
		log.appendChild(document.createTextNode(msg));
	}
}

/*
 * Show what we have been editing in the normal log view area
 * as a preview of what the real thing will look like.
 */
function previewLog(rev)
{
	// Get the message and start putting it into the log
	showLog(rev,document.getElementById('LogEd:' + rev).value);
}

/*
 * End the editing - hides the edit textarea and displays
 * the edit button again.
 */
function endEdit(rev)
{
	var details = getDetail(rev);
	details.style.display = '';

	// remember the edit button and hide it...
	details.editButton.style.display = '';
	details.editButton = null;

	// Hide the edit area
	document.getElementById('LogEdit:' + rev).style.display = 'none';
}

/*
 * Cancel the log edit by restoring the original log message
 * and ending the edit state for this revision.
 */
function cancelLog(rev)
{
	// Revert to the value before the edit...
	showLog(rev,document.getElementById('LogEd:' + rev).original);

	// And end the edit...
	endEdit(rev);
}

/*
 * Start the "save" operation for the edited log message.
 * This checks to see if any changes have been made and
 * if there are no changes it acts just like a cancel.
 * (No server traffic if there is no actual content change)
 */
function saveLog(rev)
{
	// Hide the edit area as we are now "down" editing
	document.getElementById('LogEdit:' + rev).style.display = 'none';

	// Now, lets get the XMLHTTP object
	var details = getDetail(rev);
	details.xml = getXMLHTTP();

	var ed = document.getElementById('LogEd:' + rev);
	if (ed.value == ed.original)
	{
		// No change so just cancel the thing...
		cancelLog(rev);
	}
	else
	{
		if (details.xml)
		{
			details.xml.onreadystatechange = function() { saveLogCheck(rev); };
			details.xml.open("POST",'?Insurrection=savelog',true);
			details.xml.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
			details.xml.send('rev=' + rev + '&newLog=' + escape(ed.value));

			// Show that we are saving...
			showLog(rev,'...saving...');
		}
		else
		{
			// Revert to the value from before we edited...  (no XMLHTTP support)
			showLog(rev,ed.original);

			// No need to restore the edit button if there is no XMLHTTP support
			details.editButton = null;
		}
	}
}

/*
 * This is the callback for the XMLHTTP request
 * It handles the final disposition of the save operation
 */
function saveLogCheck(rev)
{
	var details = getDetail(rev);
	if ((details.xml) && (details.xml.readyState == 4))
	{
		if (details.xml.status == 200)
		{
			previewLog(rev);
			endEdit(rev);
		}
		else
		{
			cancelLog(rev);
			alert('Log save failed: ' + details.xml.statusText);
		}
		details.xml = null;
	}
}

