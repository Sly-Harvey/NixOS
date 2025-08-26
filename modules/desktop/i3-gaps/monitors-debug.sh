#!/usr/bin/env bash

echo "=== Simple EDID Debug ==="

echo "All DRM connectors:"
ls -la /sys/class/drm/card*/

echo -e "\nConnected DRM connectors:"
for drm_path in /sys/class/drm/card*/; do
    if [[ -f "${drm_path}status" ]]; then
        connector=$(basename "$drm_path")
        status=$(cat "${drm_path}status" 2>/dev/null || echo "unknown")
        echo "$connector: $status"
        
        if [[ "$status" == "connected" ]]; then
            edid_file="${drm_path}edid"
            if [[ -f "$edid_file" ]]; then
                size=$(stat -f%z "$edid_file" 2>/dev/null || stat -c%s "$edid_file" 2>/dev/null || echo "0")
                echo "  EDID file: $edid_file (size: $size bytes)"
                
                if [[ "$size" -gt 0 ]]; then
                    echo "  EDID content:"
                    edid-decode "$edid_file" 2>/dev/null | grep -E "(Manufacturer|Product|Serial number|Display Product Name)" | sed 's/^/    /'
                else
                    echo "  EDID file is empty"
                fi
            else
                echo "  No EDID file found"
            fi
            echo ""
        fi
    fi
done

echo -e "\nDirect EDID check for each connected connector:"
for edid_file in /sys/class/drm/card*/edid; do
    if [[ -f "$edid_file" ]]; then
        connector=$(basename "$(dirname "$edid_file")")
        status_file="$(dirname "$edid_file")/status"
        
        if [[ -f "$status_file" ]]; then
            status=$(cat "$status_file")
            if [[ "$status" == "connected" ]]; then
                echo "=== $connector (connected) ==="
                echo "EDID file: $edid_file"
                
                # Check if file has content
                if [[ -s "$edid_file" ]]; then
                    echo "Decoding EDID:"
                    edid-decode "$edid_file" 2>/dev/null || echo "Failed to decode EDID"
                else
                    echo "EDID file exists but is empty"
                fi
                echo ""
            fi
        fi
    fi
done
