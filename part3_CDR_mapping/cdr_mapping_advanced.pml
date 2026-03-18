# PyMOL CDR Mapping & Hotspot Visualization
# File: cdr_mapping.pml
# Purpose: Visualize CDR regions and mutation hotspots for 5XKU

# ============================================================================
# BASIC SETUP
# ============================================================================

# Clear and load structure
delete all
fetch 5XKU

# Clean structure
remove solvent
remove hetatm

# Basic visualization
hide everything
show cartoon

# Color chains
color red, chain A      # HA chain A  
color orange, chain B   # HA chain B
color gray80, chain C   # Antibody chain

print "Structure loaded and cleaned"

# ============================================================================
# CDR REGION DEFINITIONS (to be updated based on analysis)
# ============================================================================

# These ranges will be updated based on actual sequence analysis
# Default Kabat numbering for heavy chain

# Define CDR regions (approximate - adjust based on sequence analysis)
select CDR1_approx, chain C and resi 31-35
select CDR2_approx, chain C and resi 50-65  
select CDR3_approx, chain C and resi 95-102

# Color CDR regions
color blue, CDR1_approx
color green, CDR2_approx
color magenta, CDR3_approx

# Show CDR regions prominently
show sticks, CDR1_approx+CDR2_approx+CDR3_approx

print "CDR regions defined and colored"

# ============================================================================
# INTERFACE ANALYSIS
# ============================================================================

# Define interface residues
select interface_5A, chain C within 5 of (chain A+B)
select interface_3A, chain C within 3 of (chain A+B)

# Show interface
show sticks, interface_5A
color yellow, interface_5A

# Highlight tight interface
color orange, interface_3A

print "Interface residues identified"

# ============================================================================
# CDR-INTERFACE OVERLAP
# ============================================================================

# Find CDR residues that are also at interface
select CDR1_interface, CDR1_approx and interface_5A
select CDR2_interface, CDR2_approx and interface_5A  
select CDR3_interface, CDR3_approx and interface_5A

# Highlight these critical residues
color cyan, CDR1_interface
color lime, CDR2_interface
color hot_pink, CDR3_interface

# Show as spheres for emphasis
show spheres, CDR1_interface+CDR2_interface+CDR3_interface

print "CDR-interface overlap identified"

# ============================================================================
# MUTATION HOTSPOT VISUALIZATION
# ============================================================================

# Define mutation hotspots (to be updated with actual analysis)
# These are placeholder - will be updated with real hotspot residues

# High priority hotspots (example positions)
select hotspot_high, chain C and resi 32+55+98+101
select hotspot_medium, chain C and resi 31+53+97+100

# Color hotspots
color red, hotspot_high      # High priority
color pink, hotspot_medium   # Medium priority

# Show hotspots prominently
show spheres, hotspot_high
show sticks, hotspot_medium

print "Mutation hotspots highlighted"

# ============================================================================
# LABELING AND ANNOTATIONS
# ============================================================================

# Label CDR regions
label CDR1_approx and name CA and resi 33, "CDR1"
label CDR2_approx and name CA and resi 57, "CDR2"  
label CDR3_approx and name CA and resi 99, "CDR3"

# Label chains
label chain A and name CA and resi 1, "HA-A"
label chain B and name CA and resi 1, "HA-B"
label chain C and name CA and resi 1, "Antibody"

print "Labels added"

# ============================================================================
# MULTIPLE VIEWS FOR DOCUMENTATION
# ============================================================================

def save_cdr_views():
    """Save multiple views for documentation"""
    
    # View 1: Overall complex
    orient
    zoom
    png CDR_overview.png, width=1200, height=900, dpi=300, ray=1
    print "Overview saved"
    
    # View 2: CDR regions focus
    orient CDR1_approx+CDR2_approx+CDR3_approx
    zoom CDR1_approx+CDR2_approx+CDR3_approx, 8
    png CDR_regions.png, width=1200, height=900, dpi=300, ray=1
    print "CDR regions saved"
    
    # View 3: Interface close-up
    orient interface_5A
    zoom interface_5A, 10
    png CDR_interface.png, width=1200, height=900, dpi=300, ray=1
    print "Interface view saved"
    
    # View 4: Mutation hotspots
    orient hotspot_high+hotspot_medium
    zoom hotspot_high+hotspot_medium, 12
    png mutation_hotspots.png, width=1200, height=900, dpi=300, ray=1
    print "Hotspots saved"

# ============================================================================
# ANALYSIS FUNCTIONS
# ============================================================================

def count_cdr_residues():
    """Count residues in each CDR region"""
    
    print "CDR Residue Counts:"
    print "CDR1: " + str(cmd.count_atoms("CDR1_approx and name CA"))
    print "CDR2: " + str(cmd.count_atoms("CDR2_approx and name CA"))  
    print "CDR3: " + str(cmd.count_atoms("CDR3_approx and name CA"))
    
    print "Interface Residue Counts:"
    print "Total interface (5A): " + str(cmd.count_atoms("interface_5A and name CA"))
    print "CDR at interface: " + str(cmd.count_atoms("(CDR1_interface+CDR2_interface+CDR3_interface) and name CA"))

def analyze_cdr_composition():
    """Analyze amino acid composition of CDRs"""
    
    print "CDR Composition Analysis:"
    
    # This would require more complex PyMOL commands
    # For now, just identify the regions
    cmd.iterate("CDR1_approx and name CA", "print resi + ' ' + resn")
    cmd.iterate("CDR2_approx and name CA", "print resi + ' ' + resn")  
    cmd.iterate("CDR3_approx and name CA", "print resi + ' ' + resn")

# ============================================================================
# CUSTOM SELECTION TOOLS
# ============================================================================

def select_cdr_sphere(cdr_name, radius=8):
    """Select residues around a CDR region"""
    
    selection_name = cdr_name + "_sphere"
    cmd.select(selection_name, cdr_name + "_approx around " + str(radius))
    cmd.show("lines", selection_name)
    print cdr_name + " sphere selected (radius: " + str(radius) + "A)"

def highlight_binding_patch():
    """Highlight the main antibody binding patch"""
    
    cmd.select("binding_patch", "chain C within 6 of (chain A+B)")
    cmd.color("wheat", "binding_patch")
    cmd.show("surface", "binding_patch")
    cmd.set("transparency", 0.3, "binding_patch")
    
    print "Binding patch highlighted"

# ============================================================================
# MAIN EXECUTION
# ============================================================================

# Run basic analysis
count_cdr_residues()

# Save views
save_cdr_views()

print "CDR mapping visualization complete!"
print "Files saved:"
print "  - CDR_overview.png"
print "  - CDR_regions.png"  
print "  - CDR_interface.png"
print "  - mutation_hotspots.png"

print "\nTo run additional analysis:"
print "  count_cdr_residues()       - Count residues"
print "  analyze_cdr_composition()  - Show amino acids"
print "  highlight_binding_patch()  - Show binding surface"
print "  select_cdr_sphere('CDR1', 10) - Select around CDR"

# ============================================================================
# MUTATION DESIGN PREPARATION
# ============================================================================

print "\nFor AI mutation design:"
print "1. Identify exact residue numbers from analysis"
print "2. Update hotspot selections with real data"
print "3. Focus on CDR3 for highest impact mutations"
print "4. Consider interface residues for affinity improvement"
