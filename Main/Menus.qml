/*
    Copyright (C) 2019 Joshua Wade

    This file is part of Anthem.

    Anthem is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 3 of
    the License, or (at your option) any later version.

    Anthem is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with Anthem. If not, see
                        <https://www.gnu.org/licenses/>.
*/

import QtQuick 2.13

Item {
    id: menuContainer
    property Component menuComponent

    property int _idCounter: 0

    property int openMenuCount: 0

    function open(x, y, menuItems) {
        if (menuComponent === null)
            menuComponent = Qt.createComponent("MenuSingleton.qml");

        if (menuComponent.status === Component.Ready) {
            let options = {
                id: toString(_idCounter),
                x: x,
                y: y,
                width: 100,
                menuItems: menuItems
            }

            let menu = menuComponent.createObject(menuContainer, options);
            menu.closed.connect(() => {
                closeAfter(toString(_idCounter));
            });
            _idCounter++;
            openMenuCount++;
            return toString(_idCounter - 1);
        }
        else if (menuComponent.status === Component.Error) {
            console.error("Error loading component:", menuComponent.errorString());
        }
        else {
            console.error("menuComponent.status is not either \"ready\" or \"error\". This may mean the component hasn't loaded yet. This shouldn't be possible.");
        }
        return '-1';
    }

    function closeAt(id) {
        if (typeof id !== "string")
            id = toString(id);

        for (let i = 1; i < children.length; i++) {
            if (children[i].id === id) {
                children[i].destroy();
                openMenuCount--;
                return id;
            }
        }

        return '-1';
    }

    function closeAfter(id) {
        if (typeof id !== "string")
            id = toString(id);

        let destroyStarted = false;

        for (let i = 1; i < children.length; i++) {

            if (children[i].id === id) {
                destroyStarted = true;
            }

            if (destroyStarted) {
                children[i].destroy();
                openMenuCount--;
            }
        }
    }

    function closeAll() {
        for (let i = 1; i < children.length; i++) {
            children[i].destroy();
            openMenuCount--;
        }
    }

    function closeLast() {
        children[children.length - 1].destroy();
        openMenuCount--;
    }

    focus: openMenuCount > 0

    Keys.onEscapePressed: {
        closeLast();
    }

    MouseArea {
        id: mouseArea
        anchors.fill: openMenuCount > 0 ? parent : undefined
        width: openMenuCount < 1 ? 0 : undefined
        height: openMenuCount < 1 ? 0 : undefined

        onPressed: {
            closeAll();
        }
    }
}
