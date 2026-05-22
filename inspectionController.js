const { InspectionRequest, Vehicle, User, InspectionReport, Notification } = require('../models');

// @desc    Create inspection request
// @route   POST /api/inspections
// @access  Private/Customer
exports.createInspection = async (req, res) => {
    try {
        const { vehicle, preferred_date, preferred_time, location } = req.body;

        // Create inspection request
        const inspection = await InspectionRequest.create({
            customer_id: req.user.id,
            preferred_date,
            preferred_time,
            location,
            status: 'pending'
        });

        // Create vehicle record
        await Vehicle.create({
            inspection_request_id: inspection.id,
            ...vehicle
        });

        // Create notification for admin
        const admins = await User.findAll({ where: { role: 'admin' } });
        for (const admin of admins) {
            await Notification.create({
                user_id: admin.id,
                type: 'inspection_requested',
                title: 'New Inspection Request',
                message: `New inspection request from ${req.user.full_name}`,
                related_inspection_id: inspection.id
            });
        }

        res.status(201).json({
            message: 'Inspection request created successfully',
            inspection
        });
    } catch (error) {
        console.error('Create inspection error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};

// @desc    Get all inspections
// @route   GET /api/inspections
// @access  Private
exports.getAllInspections = async (req, res) => {
    try {
        let whereClause = {};

        // Filter based on role
        if (req.user.role === 'customer') {
            whereClause.customer_id = req.user.id;
        } else if (req.user.role === 'inspector') {
            whereClause.inspector_id = req.user.id;
        }

        const inspections = await InspectionRequest.findAll({
            where: whereClause,
            include: [
                { model: User, as: 'customer', attributes: ['id', 'full_name', 'email', 'phone'] },
                { model: User, as: 'inspector', attributes: ['id', 'full_name', 'email', 'phone'] },
                { model: Vehicle }
            ],
            order: [['created_at', 'DESC']]
        });

        res.json({ inspections });
    } catch (error) {
        console.error('Get inspections error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};

// @desc    Get inspection by ID
// @route   GET /api/inspections/:id
// @access  Private
exports.getInspectionById = async (req, res) => {
    try {
        const inspection = await InspectionRequest.findByPk(req.params.id, {
            include: [
                { model: User, as: 'customer', attributes: ['id', 'full_name', 'email', 'phone'] },
                { model: User, as: 'inspector', attributes: ['id', 'full_name', 'email', 'phone'] },
                { model: Vehicle },
                { model: InspectionReport }
            ]
        });

        if (!inspection) {
            return res.status(404).json({ error: 'Inspection not found' });
        }

        res.json({ inspection });
    } catch (error) {
        console.error('Get inspection error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};

// @desc    Assign inspector to inspection
// @route   PUT /api/inspections/:id/assign
// @access  Private/Admin
exports.assignInspector = async (req, res) => {
    try {
        const { inspector_id } = req.body;

        const inspection = await InspectionRequest.findByPk(req.params.id);
        if (!inspection) {
            return res.status(404).json({ error: 'Inspection not found' });
        }

        await inspection.update({
            inspector_id,
            status: 'assigned'
        });

        // Notify inspector
        await Notification.create({
            user_id: inspector_id,
            type: 'inspector_assigned',
            title: 'New Inspection Assigned',
            message: 'You have been assigned a new inspection',
            related_inspection_id: inspection.id
        });

        res.json({ message: 'Inspector assigned successfully', inspection });
    } catch (error) {
        console.error('Assign inspector error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};

// @desc    Update inspection status
// @route   PUT /api/inspections/:id/status
// @access  Private
exports.updateStatus = async (req, res) => {
    try {
        const { status, scheduled_date } = req.body;

        const inspection = await InspectionRequest.findByPk(req.params.id);
        if (!inspection) {
            return res.status(404).json({ error: 'Inspection not found' });
        }

        await inspection.update({ status, scheduled_date });

        res.json({ message: 'Status updated successfully', inspection });
    } catch (error) {
        console.error('Update status error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};
