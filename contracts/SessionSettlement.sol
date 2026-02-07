// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SessionSettlement
 * @notice Minimal smart contract for recording trading session settlements and revenue share.
 * This contract stores settlement records on-chain for transparency and enables revenue distribution.
 */
contract SessionSettlement {
    /**
     * @notice Settlement record for a trading session.
     */
    struct Settlement {
        string sessionId;
        address userAddress;
        string agentId;
        int256 pnlUsd; // Can be negative for losses
        string nitroliteSessionId;
        uint256 timestamp;
        bool settled;
    }

    /**
     * @notice Revenue share configuration for agents.
     */
    struct RevenueShare {
        address agentRevenueWallet;
        uint256 shareBps; // Basis points (e.g., 1000 = 10%)
    }

    // Mapping from sessionId to settlement record
    mapping(string => Settlement) public settlements;

    // Mapping from agentId to revenue share config
    mapping(string => RevenueShare) public agentRevenueShares;

    // Events
    event SessionSettled(
        string indexed sessionId,
        address indexed userAddress,
        string indexed agentId,
        int256 pnlUsd,
        string nitroliteSessionId
    );

    event RevenueShareUpdated(
        string indexed agentId,
        address revenueWallet,
        uint256 shareBps
    );

    /**
     * @notice Record a session settlement on-chain.
     * @param sessionId Unique identifier for the trading session
     * @param userAddress Address of the user who hired the agent
     * @param agentId Identifier of the agent that executed the session
     * @param pnlUsd Profit and loss in USD (can be negative)
     * @param nitroliteSessionId Yellow Network Nitrolite session ID
     */
    function settleSession(
        string memory sessionId,
        address userAddress,
        string memory agentId,
        int256 pnlUsd,
        string memory nitroliteSessionId
    ) external {
        require(
            settlements[sessionId].timestamp == 0,
            "Session already settled"
        );

        settlements[sessionId] = Settlement({
            sessionId: sessionId,
            userAddress: userAddress,
            agentId: agentId,
            pnlUsd: pnlUsd,
            nitroliteSessionId: nitroliteSessionId,
            timestamp: block.timestamp,
            settled: true
        });

        emit SessionSettled(
            sessionId,
            userAddress,
            agentId,
            pnlUsd,
            nitroliteSessionId
        );
    }

    /**
     * @notice Get settlement details for a session.
     * @param sessionId The session ID to query
     * @return settlement The settlement record
     */
    function getSettlement(
        string memory sessionId
    ) external view returns (Settlement memory) {
        return settlements[sessionId];
    }

    /**
     * @notice Set or update revenue share configuration for an agent.
     * @param agentId Identifier of the agent
     * @param revenueWallet Address where agent revenue should be sent
     * @param shareBps Revenue share in basis points (e.g., 1000 = 10%)
     */
    function setAgentRevenueShare(
        string memory agentId,
        address revenueWallet,
        uint256 shareBps
    ) external {
        require(shareBps <= 10000, "Share cannot exceed 100%");
        require(revenueWallet != address(0), "Invalid revenue wallet");

        agentRevenueShares[agentId] = RevenueShare({
            agentRevenueWallet: revenueWallet,
            shareBps: shareBps
        });

        emit RevenueShareUpdated(agentId, revenueWallet, shareBps);
    }

    /**
     * @notice Get revenue share configuration for an agent.
     * @param agentId The agent ID to query
     * @return revenueShare The revenue share configuration
     */
    function getAgentRevenueShare(
        string memory agentId
    ) external view returns (RevenueShare memory) {
        return agentRevenueShares[agentId];
    }
}
