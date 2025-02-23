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

Rectangle {
    property real value: 0
    property bool isVertical: false

    color: Qt.rgba(1, 1, 1, 0.09)
    radius: 0.5

    Rectangle {
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        height: isVertical ? parent.height * value : parent.height
        width: isVertical ? parent.width : parent.width * value

        radius: 0.5
        color: Qt.hsla(162 / 360, 0.5, 0.43, 1);
    }
}
