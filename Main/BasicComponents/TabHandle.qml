/*
    Copyright (C) 2019 Joshua Wade

    This file is part of Anthem.

    Anthem is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 3 of
    the License, or (at your option) any later version.

    Anthem is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with Anthem. If not, see
                        <https://www.gnu.org/licenses/>.
*/

import QtQuick 2.0

Button {
    id: tabHandle
    property string title: "New project"
    property bool isSelected
    property int index

    signal btnClosePressed(int index)
    signal selected(int index)

    textContent: title
    textFloat: "left"

    isHighlighted: isSelected

    onPress: selected(index)

    Button {
        height: parent.height
        width: parent.height
        anchors.right: parent.right
        anchors.top: parent.top

        showBorder: false
        showBackground: false

        imageSource: "Images/Close.svg"
        imageWidth: 8
        imageHeight: 8

        isHighlighted: isSelected

        onPress: btnClosePressed(tabHandle.index)
    }
}
