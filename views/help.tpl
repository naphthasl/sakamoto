<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>help</title>
		
		<link rel="stylesheet" href="./static/main.css" />
	</head>
	<body>
		<h1>Internal Documentation</h1>

        <p>New to Sakamoto? Unsure what anything means at all? Same! We're all humans! We all have no idea what we're doing! Scream!</p>

        <p>Sakamoto allows you to create a tree of editable Markdown pages (and external links) which you can use to create a really neat website.</p>

        <p>To create your first document, you can either <a href="./action/-1?type=edit">edit your hompage</a> or create a new document with your homepage as the parent. This guide will teach you how to do the latter option, as it'll give you way more useful information.</p>

        <ol>
            <li>First, hover over "Home" in the site index and click on the cog wheel/settings icon to the right.</li>
            <li>A list of actions will appear. For the home page, the range of available actions is somewhat limited in order to prevent you from shooting yourself in the foot.</li>
            <li>Click "New child."</li>
            <li>A new entry in the menu under "Home" will appear called "New Menu Object." Hover over it in the site index and click <b>Rename</b>.</li>
            <li>The rename dialog will appear. Change the name to anything you like, and click <b>Submit</b>.</li>
            <li>If you'd like the document to be accessible (in other words, if you'd like regular users to be able to view the content), click <b>Toggle Disabled</b>. This will make it possible for users to click on the link in the site index.</li>
            <li>Finally, click <b>Edit</b> in the actions menu for your new document in order to change the document contents.</li>
            <li>Use the built-in markdown editor to format your document however you'd like.</li>
            <li>Click <b>Submit</b> to change the document contents.</li>
        </ol>

        <p>Congratulations! After following the instructions above, you will have created your first document, toggled some permission properties on it and edited it.</p>

        <p>But what if you'd like a menu item that actually acts as a link, and takes the user to a remote location? Simply follow the instructions below...</p>

        <ol>
            <li>Follow <i>steps 1 through to 7</i> above. Once you're in the document editor, scroll down to the bottom and paste the link you'd like the menu item to redirect to into the <b>External Link</b> box.</li>
            <li>Tick the checkbox to the right of the <b>External Link</b> input.</li>
            <li>Click <b>submit</b> to enable the external link.</li>
            <li>Click on your new link in the site index, and it should take you to your defined remote location.</li>
            <li>If you'd like the user to be able to follow the external link while keeping the Sakamoto menu and navbar, navigate to the action menu and click <b>Toggle Target</b> in such a way that it remains in the enabled state. Please note that this will <i>only</i> work for URLs on the same domain.</li>
        </ol>

        <p>Congratulations, that's pretty much all you really needed to know to become a master of Sakamoto. Here are some other cool features you should know about...</p>

        <ul>
            <li>Every document can have a child document. The site index can have infinite depth.</li>
            <li>You chan change the icon for any document with the <b>Change Icon</b> button in the action menu for the document.</li>
            <li>"Toggle Collapsed" will make the document and its children appear collapsed in the site index by default.</li>
            <li>"Toggle Hidden" will prevent a document and its children from appearing in the menu at all. (Except for admins)</li>
            <li>You can move a document to a new parent document with the <b>New Parent</b> button in the action menu. The Parent ID input field requires one of the integers in the yellow boxes shown to the right of document names in the site index when you hover over them. Those are their IDs in the database.</li>
            <li>You can move a document up or down in the site index tree with the <b>Move Up</b> and <b>Move Down</b> buttons in the action menu.</li>
            <li>The icon picker has a working search bar in the bottom right.</li>
            <li>You can print documents with the print button in the top right of the navbar.</li>
            <li>You can upload static files, such as images, in the <a href="./files">static files list</a>. Once you upload a file there, you'll be given a URL to the file that you can copy. You may reference these URLs in your documents (relatively or absolutely) in order to include assets such as images.</li>
            <li>You can change site-wide options such as the tab title and copyright message(s) using the <a href="./options">site wide options</a> menu.</li>
            <li>You can delete user comments if they break your rules. If you're an admin, each comment will have a delete button.</li>
            <li>You can ban users in the <a href="./users">user management</a> menu.</li>
        </ul>

		% include('shared_js.tpl', navback = './')
	</body>
</html>
