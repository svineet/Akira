/*
* Copyright (c) 2019-2020 Alecaddd (https://alecaddd.com)
*
* This file is part of Akira.
*
* Akira is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* Akira is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with Akira. If not, see <https://www.gnu.org/licenses/>.
*
* Authored by: Giacomo Alberini <giacomoalbe@gmail.com>
*/

public class Akira.Models.LayerModel : Models.ItemModel {
    public string name {
        owned get {
            return item.name != null ? item.name : item.id;
        }
        set {
            item.name = value;
        }
    }

    public string icon {
        get {
            return item.layer_icon;
        }
    }

    public bool? is_visible {
        owned get {
            return item.visibility == Goo.CanvasItemVisibility.VISIBLE;
        }
        set {
            item.visibility = value
                ? Goo.CanvasItemVisibility.VISIBLE
                : Goo.CanvasItemVisibility.INVISIBLE;
        }
    }

    public bool? is_locked {
        get {
            return item.locked;
        }
        set {
            item.locked = value;

            if (item.locked) {
                selected = false;
            }
        }
    }

    public bool selected {
        get {
            return item.selected;
        }
        set {
            item.selected = value;
            debug (@"Setting selected: $(value) to $(item.id)");
        }
    }

    public bool is_artboard {
        get {
            return item is Akira.Lib.Models.CanvasArtboard;
        }
    }

    public Akira.Models.ListModel items { get; set; }

    public LayerModel (
        Lib.Models.CanvasItem item,
        Akira.Models.ListModel list_model
    ) {
        Object (
            item: item,
            list_model: list_model
        );

        if (is_artboard) {
            items = new Akira.Models.ListModel ();
        }
    }

    public void add_child_item (Akira.Lib.Models.CanvasItem item) {
        if (!is_artboard) {
            return;
        }

        items.add_item.begin (new Akira.Models.LayerModel (item, items));
    }

    public void remove_child_item (Akira.Lib.Models.CanvasItem item) {
        if (!is_artboard) {
            return;
        }

        var item_model = items.find_item (item);

        if (item_model == null) {
            return;
        }

        items.remove_item.begin (item_model);
    }

    public string to_string () {
        return "Layer: %s Label: %s Hidden: %d Lock: %d".printf (item.id, name, 0, 0);
    }
}
